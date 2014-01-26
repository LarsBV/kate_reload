# -*- coding: utf-8 -*-

from .kate_reload import *


@kate.init
def init():
  global kate_reload
  kate_reload = KateReload()
  
@kate.unload
def unload():
    global kate_reload
    if kate_reload:
        del kate_reload
        kate_reload = None
