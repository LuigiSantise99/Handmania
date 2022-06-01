# -*- coding: utf-8 -*-
'''Custom simfile parser and miner.

This module helps parsing and extracting relevant infomration from a single
simfile specified.

Todo:
    * Upgrade `_there_are_synchronous_notes` to make it more precise.
    * Create a private function to encode the audio file.
'''

from .from_simfile import from_simfile
from .errors.song_has_unsupported_notes_error import SongWithUnsupportedNotesError
from .errors.invalid_file_error import InvalidFileError
from .errors.wanted_chart_not_found_error import WantedChartNotFoundError
