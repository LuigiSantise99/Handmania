class SongWithPartialInformationError(Exception):
    '''The specified song has one or more null fields.
    '''
    
    def __init__(self) -> None:
        super().__init__('The song has one or more null fields')
