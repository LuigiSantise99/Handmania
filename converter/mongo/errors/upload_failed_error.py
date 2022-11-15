class UploadFailedError(Exception):
    '''The upload to the MongoDB database failed.
    '''
    
    def __init__(self, path: str) -> None:
        super().__init__('Upload to the MongoDB database failed')
