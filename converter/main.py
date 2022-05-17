import json
import sm


if __name__ == '__main__':
    song = sm.from_simfile('songs/mecha_tribe_assault.ssc', strict=False)
    print(json.dumps(song, indent=4))
