import json
import mongo
import os
import sys
from typing import Any, Dict


if __name__ == '__main__':
    for song_file_name in os.listdir('inout/converted/'):
        # The .gitkeep file is ignored.
        if song_file_name == ".gitkeep":
            continue

        with open(f'inout/converted/{song_file_name}') as song_file:
            song: Dict[str, Any] = json.load(song_file)

            try:
                mongo.upload_song('mongodb://localhost:27017', 'handmania', 'songs', song)
            except Exception as exception:
                print(f'Upload of song "{song_file_name}" raised an exception. {exception}. Skipping it', file=sys.stderr)
                continue
        
            print(f'Song {song_file_name} successfully uploaded')
