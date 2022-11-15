class InvalidSongPathError(Exception):
    '''The specified file path relative to a song is invalid.

    Args:
        path (str): Path of the specified song file.
    '''

    def __init__(self, path: str) -> None:
        super().__init__(f'Invalid song file "{path}"')
