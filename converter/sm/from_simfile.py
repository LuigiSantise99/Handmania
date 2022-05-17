import simfile
from typing import Any, Dict, List

from sm.errors.song_has_synchronous_notes_error import SongWithSynchronousNotesError
from sm.errors.invalid_file_error import InvalidFileError
from sm.errors.wanted_chart_not_found_error import WantedChartNotFoundError


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
                'start': '00:00:000000',
                'length': '00:01:000000',
                'bpms': 180.00,
                'notes': [
                    ['0000', '0000', '0000', '0000']
                ],
                'src': _b64encode_song(song.ogg)
            }

    Raises:
        InvalidFileError: If the specified file does not exists or has
            an invalid format.
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

    notes: List[List[str]] = _get_beginner_chart_notes(file.charts)

    if strict and _there_are_synchronous_notes(notes):
        raise SongWithSynchronousNotesError()

    return {
        'title': file.title,
        'artist': file.artist,
        'genre': file.genre,
        'start': file.samplestart,
        'length': file.samplelength,
        'bpms': file.bpms,
        'notes': notes,
        'src': ''
    }


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


def _there_are_synchronous_notes(notes: List[List[str]]) -> bool:
    '''Checks if there are synchronous notes.

    Args:
        notes (List[List[str]]): The notes of the song.

    Returns:
        bool: True if there are synchronous notes. False otherwise.
    '''
    for note_groups in notes:
        for note in note_groups:
            sum: int = 0

            for single_note in note:
                sum += int(single_note)

            if sum > 1:
                return True

    return False
