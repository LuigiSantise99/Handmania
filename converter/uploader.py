import mongo
import os
import sys


if __name__ == '__main__':
    for song_file_name in os.listdir('inout/converted/'):
        # The .gitkeep file is ignored.
        if song_file_name == ".gitkeep":
            continue

        try:
            mongo.upload_song('mongodb://localhost:27017', 'handmania', 'songs', f'inout/converted/{song_file_name}')
        except Exception as exception:
            print(f'Upload of song "{song_file_name}" raised an exception. {exception}. Skipping it', file=sys.stderr)
            continue
        
        print(f'Song {song_file_name} successfully uploaded')
