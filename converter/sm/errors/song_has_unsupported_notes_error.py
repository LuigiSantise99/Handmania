class SongWithUnsupportedNotesError(Exception):
    '''The specified song has some unsupported notes at some point.
    '''
    
    def __init__(self) -> None:
        super().__init__('The song has unsupported notes at some point')
