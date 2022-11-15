class WantedChartNotFoundError(Exception):
    '''The wanted chart is not supported by the song.
    '''
    
    def __init__(self) -> None:
        super().__init__('There is not the single palyer beginner chart for the song')
