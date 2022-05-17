import simfile


def from_simfile(desatination, strict = True):
    file = simfile.open(desatination)

    notes = _get_beginner_chart_notes(file.charts)

    if strict and _there_are_synchronous_notes(notes):
        return None

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


def _get_beginner_chart_notes(charts):
    for chart in charts:
        if chart.difficulty == 'Beginner' and chart.stepstype == 'dance-single':
            result = []

            for notes in chart.notes.strip().split(','):
                result.append(notes.strip().split('\n'))
            
            return result

    return None


def _there_are_synchronous_notes(notes):
    for note_groups in notes:
        for note in note_groups:
            # TODO: improve the detection algorithm.
            sum = 0

            for single_note in note:
                sum += int(single_note)

            if sum > 1:
                return True

    return False
