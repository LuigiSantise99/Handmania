# -*- coding: utf-8 -*-
'''Custom MongoDB song uploader.

This module helps uploading JSON files relative to previously
converted songs.
'''

from .upload_song import upload_song
from .errors.invalid_song_format_error import InvalidSongFromatError
from .errors.upload_failed_error import UploadFailedError
