class SongWithSynchronousNotesError(Exception):
    '''The specified song has some synchronous notes at some point.
    '''

    def __init__(self) -> None:
        super().__init__('There song has synchronous notes at some point')
