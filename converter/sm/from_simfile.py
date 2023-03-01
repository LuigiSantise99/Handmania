import simfile
from typing import Any, Dict, List

from sm.errors.song_has_unsupported_notes_error import SongWithUnsupportedNotesError
from sm.errors.invalid_file_error import InvalidFileError
from sm.errors.wanted_chart_not_found_error import WantedChartNotFoundError
from sm.errors.song_with_partial_information_error import SongWithPartialInformationError


def from_simfile(desatination: str, strict: bool = True) -> Dict[str, Any]:
    '''Reads and extracts relevant information from the specified simfile.

    Args:
        desatination (str): The path of the wanted simfile.
        strict (bool, optional): If synchronous notes are not allowed.
            Defaults to True.

    Returns:
        Dict[str, Any]: The relevant parts of the simfile.
            {
                'title': 'Song title',
                'artist': 'Artist',
                'genre': 'Genre',
                'preview': {
                    'start': '00:00:000000',
                    'length': '00:01:000000'
                },
                'notes': [
                    [0, 0, 0, 0],
                    [1, 0, 0, 0],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1]
                ]
            }

    Raises:
        InvalidFileError: If the specified file does not exists or has
            an invalid format.
        SongWithPartialInformationError: If the specified song has one or
            more null fields.
        WantedChartNotFoundError: If there is no single player beginner
            chart for the song.
        SongWithSynchronousNotesError: If `strict` is True and there are
            synchronous notes in the song.
    '''
    file: simfile.base.BaseSimfile = None

    try:
        file = simfile.open(desatination)
    except:
        raise InvalidFileError(desatination)
    
    if _there_are_null_fields(file):
        raise SongWithPartialInformationError()

    notes: List[List[str]] = _get_beginner_chart_notes(file.charts)

    if strict and not _is_a_valid_chart(notes):
        raise SongWithUnsupportedNotesError()
    
    notes = _linearize_chart_notes(notes)

    return {
        'title': str(file.title),
        'artist': str(file.artist),
        'genre': str(file.genre),
        'preview': {
            'start': file.samplestart,
            'length': file.samplelength
        },
        'notes': notes
    }


def _there_are_null_fields(file: simfile.base.BaseSimfile) -> bool:
    '''Checks whether the song file has null relevant fields.

    Args:
        file (simfile.base.BaseSimfile): The song file
    
    Returns:
        bool: True if there are null relevant fields, false otherwise.
    '''
    return file.title == None or file.artist == None or file.genre == None or file.samplestart == None or file.samplelength == None


def _get_beginner_chart_notes(charts: List[simfile.base.BaseChart]) -> List[List[str]]:
    '''Retrieves the beginner chart notes of the song.

    Args:
        charts (List[simfile.base.BaseChart]): The raw representation of the
            "note" attribute.

    Returns:
        List[List[str]]: The list of beginner notes of the song.
            [
                ['0000', '0000', '0000', '0000'],
                ['0010', '1000', '0200', '0301']
            ]

    Raises:
        WantedChartNotFoundError: If there is no single player beginner
            chart for the song.
    '''
    for chart in charts:
        if chart.difficulty == 'Beginner' and chart.stepstype == 'dance-single':
            result: List[List[str]] = []

            for notes in chart.notes.strip().split(','):
                result.append(notes.strip().split('\n'))
            
            return result

    raise WantedChartNotFoundError()


def _is_a_valid_chart(chart: List[List[str]]) -> str:
    '''Checks if there are unsupported notes.

    Args:
        chart (List[List[str]]): The notes of the song.

    Returns:
        bool: True if the chart does not have unsupported notes, False otherwise.
    '''
    for note_groups in chart:
        for notes_string in note_groups:
            if '4' in notes_string:
                return False
            
    return True


def _linearize_chart_notes(chart: List[List[str]]) -> List[int]:
    '''Linearizes the chart note making it flat.

    Args:
        chart: (List[List[str]]): The notes of the song.
    
    Returns:
        List[int]: The linearized list of the notes chart.
            [
                [0, 0, 0, 0],
                [1, 0, 0, 0]
            ]
        
    Raises:
        ValueError: if a note in the chart is not an integer.
    '''
    linearized_chart: List[str] = [item for sublist in chart for item in sublist]
    result: List[int] = []

    for row in linearized_chart:
        result.append([int(note) for note in row])
    
    return result
