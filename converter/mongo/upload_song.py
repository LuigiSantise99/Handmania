import json
import pymongo
from typing import Any, Dict, TextIO

from mongo.errors.invalid_song_format_error import InvalidSongFromatError
from mongo.errors.invalid_song_path_error import InvalidSongPathError
from mongo.errors.upload_failed_error import UploadFailedError


CORRECT_SONG_KEYS = ['title', 'artist', 'genre', 'start', 'length', 'bpms', 'notes', 'b64']


def upload_song(host: str, database: str, collection: str, song_source: str) -> None:
    '''Reads and uploads a song to the specified MongoDB database and collection.

    Args:
        host (str): The path to the MongoDB host.
        database (str): The name of the database where to upload songs.
        collection (str): The name of the collection in the database that
            contains songs.
        song_source (str): The path to the local file containing the song.

    Raises:
        InvalidSongFromatError: If the retrieved song does not conform to
            the standard song object format.
        InvalidSongPathError: If the specified path to the song file does
            not exists.
        UploadFailedError: If the insertion of the song in the database is
            not successfull.
    '''
    song: Dict[str, Any] = _get_song_dictionary_from_source(song_source)

    if not _is_a_valid_song(song):
        raise InvalidSongFromatError()
    
    _upload_song_to_mongodb(host, database, collection, song)


def _get_song_dictionary_from_source(song_source: str) -> Dict[str, Any]:
    '''Retrieves the song from the specified file path.

    Args:
        song_source (str): The path to the file containing the
            wanted song.

    Returns:
        Dict[str, Any]: The dictionary representing the song.
            {
                'title': 'Song title',
                'artist': 'Artist',
                'genre': 'Genre',
                'start': '00:00:000000',
                'length': '00:01:000000',
                'bpms': 180.00,
                'notes': [
                    ['0000', '0000', '0000', '0000']
                ],
                'b64': '...'
            }

    Raises:
        InvalidSongPathError: If the specified path to the song file does
            not exists.
    '''
    song: Dict[str, Any]

    try:
        file: TextIO = open(song_source)
        song = json.load(file)
    except:
        raise InvalidSongPathError(song_source)

    return song


def _is_a_valid_song (song: Dict[str, Any]) -> bool:
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


def _upload_song_to_mongodb(host: str, database: str, collection: str, song: Dict[str, Any]) -> None:
    '''Uploads a song to the specified MongoDB database and collection.

    Args:
        host (str): The path to the MongoDB host.
        database (str): The name of the database where to upload songs.
        collection (str): The name of the collection in the database that
            contains songs.
        song (Dict[str, Any]): The dictionary containing the song.

    Raises:
        UploadFailedError: If the insertion of the song in the database is
            not successfull.
    '''
    client = pymongo.MongoClient(host)
    
    result = client[database][collection].insert_one(song)
    if not result.acknowledged:
        raise UploadFailedError()
    