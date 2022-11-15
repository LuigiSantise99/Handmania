class InvalidSongFromatError(Exception):
    '''The specified song has an invalid format.
    '''

    def __init__(self) -> None:
        super().__init__(f'Invalid song format')
