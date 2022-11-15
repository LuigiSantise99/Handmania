import pymongo
from typing import Any, Dict, TextIO

from mongo.errors.invalid_song_format_error import InvalidSongFromatError
from mongo.errors.upload_failed_error import UploadFailedError


CORRECT_SONG_KEYS = ['title', 'artist', 'genre', 'start', 'length', 'bpms', 'notes', 'b64']


def upload_song(host: str, database: str, collection: str, song: Dict[str, Any]) -> None:
    '''Uploads a song to the specified MongoDB database and collection.

    Args:
        host (str): The path to the MongoDB host.
        database (str): The name of the database where to upload songs.
        collection (str): The name of the collection in the database that
            contains songs.
        song (Dict[str, Any]): The dictionary containing the song.

    Raises:
        InvalidSongFromatError: If the specified song does not conform to
            the standard format
        UploadFailedError: If the insertion of the song in the database is
            not successfull.
    '''
    if not _is_a_valid_song(song):
        raise InvalidSongFromatError()

    client = pymongo.MongoClient(host)
    
    result = client[database][collection].insert_one(song)
    if not result.acknowledged:
        raise UploadFailedError()


def _is_a_valid_song(song: Dict[str, Any]) -> bool:
    '''Checks if the specified song conforms to the standard song format.

    Args:
        chart (Dict[str, Any]): The song to check.

    Returns:
        bool: True if the song conforms to the standard song format, False otherwise.
    '''
    for key in song.keys():
        if not key in CORRECT_SONG_KEYS:
            return False
    
    return len(song.keys()) == len(CORRECT_SONG_KEYS)
