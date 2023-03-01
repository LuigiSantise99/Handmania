import base64
import json
from mutagen.mp3 import MP3
import os
import re
import sm
import sys
from typing import Any, Dict


def _get_thumbnail_file_name(song_name: str) -> str:
    '''Gathers the correct thumbnail file name for the specified song.

    Args:
        song_name (str): The name of the song.
    
    Returns:
        str: The wanted file name for the thumbnail.
    '''
    thumbnail_pattern: re.Pattern = re.compile(f'^{song_name}-jacket.(?:jpg|jpeg|png)$', flags=re.IGNORECASE)

    for file_name in os.listdir(f'inout/songs/{song_name}/'):
        if thumbnail_pattern.match(file_name):
            return file_name
    
    return ''


if __name__ == '__main__':
    for song_name in os.listdir('inout/songs/'):
        thumbnail_file_name: str = ""
        
        try:
            thumbnail_file_name = _get_thumbnail_file_name(song_name)
        except NotADirectoryError as exception:
            print(f'{song_name} is not a song. Skipping it', file=sys.stderr)
            continue

        # There must be an MP3 file and a thumbnail.
        if not os.path.exists(f'inout/songs/{song_name}/{song_name}.mp3') or thumbnail_file_name == '':
            print(f'Song {song_name} has no MP3 audio or thumbnail. Skipping it', file=sys.stderr)
            continue

        try:
            converted_song: Dict[str, Any] = sm.from_simfile(f'inout/songs/{song_name}/{song_name}.sm')
        except Exception as exception:
            print(f'Song {song_name} raised an exception. {exception}. Skipping it', file=sys.stderr)
            continue

        mp3_binary: str = open(f'inout/songs/{song_name}/{song_name}.mp3', 'rb').read()
        converted_song['audio'] = base64.b64encode(mp3_binary).decode('ascii')
        
        mp3_duration_in_seconds: float = MP3(f'inout/songs/{song_name}/{song_name}.mp3').info.length
        seconds_per_note: float = mp3_duration_in_seconds / len(converted_song['notes'])
        converted_song['spn'] = seconds_per_note

        thumbnail_binary: str = open(f'inout/songs/{song_name}/{thumbnail_file_name}', 'rb').read()
        converted_song['thumbnail'] = base64.b64encode(thumbnail_binary).decode('ascii')

        with open(f'inout/converted/{song_name}.json', 'w+') as song_file:
            song_file.write(json.dumps(converted_song))
        
        print(f'Song {song_name} successfully converted')
