class InvalidFileError(Exception):
    '''The specified file path is invalid.

    Args:
        path (str): Path of the specified file.
    '''
    
    def __init__(self, path: str) -> None:
        super().__init__(f'Invalid file "{path}"')
