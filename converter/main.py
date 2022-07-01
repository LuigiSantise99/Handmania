import base64
import json
import os
import sm
import sys
from typing import Any, Dict


if __name__ == '__main__':
    for song_name in os.listdir('inout/songs/'):
        # There must be an MP3 file.
        if not os.path.exists(f'inout/songs/{song_name}/{song_name}.mp3'):
            continue

        try:
            converted_song: Dict[str, Any] = sm.from_simfile(f'inout/songs/{song_name}/{song_name}.sm')
        except Exception as exception:
            print(f'Song {song_name} raised an exception. {exception}. Skipping it', file=sys.stderr)
            continue

        mp3_binary: str = open(f'inout/songs/{song_name}/{song_name}.mp3', 'rb').read()
        converted_song['b64'] = base64.b64encode(mp3_binary).decode('ascii')

        with open(f'inout/converted/{song_name}.json', 'w+') as song_file:
            song_file.write(json.dumps(converted_song))
        
        print(f'Song {song_name} successfully converted')
