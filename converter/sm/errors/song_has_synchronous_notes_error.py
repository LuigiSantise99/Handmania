class SongWithSynchronousNotesError(Exception):
    '''The specified song has some synchronous notes at some point.
    '''

    def __init__(self, notes: str) -> None:
        super().__init__(f'There song has synchronous notes at some point: {notes}')
