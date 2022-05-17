import json
import sys
import sm
from typing import Any, Dict


if __name__ == '__main__':
    try:
        song: Dict[str, Any] = sm.from_simfile('songs/mecha_tribe_assault.ssc', strict=False)
        print(json.dumps(song, indent=4))
    except Exception as exception:
        print(f'An error occourred: {exception.message}', file=sys.stderr)
