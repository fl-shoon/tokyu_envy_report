#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os, sys, shutil
from subprocess import run
from os.path import join, abspath, split, exists
os.chdir(split(abspath(__file__))[0])
if sys.prefix == sys.base_prefix:
  if run('[[ $(< .python/req.digest) == `md5 requirements.txt` ]]', shell=True).returncode:
    shutil.rmtree('.python')
  new = not exists('.python')
  if new: run(f"python3 -m venv .python", shell=True)
  os.environ['PATH'] = join('.python','bin') + os.pathsep + os.environ['PATH']
  if new:
    req = 'lock' if exists('requirements.lock') else 'txt'
    run(f"python -m pip install --upgrade pip", shell=True)
    run(f"python -m pip install -r requirements.{req}", shell=True)
    if req == 'txt': run(f"python -m pip freeze --local > requirements.lock", shell=True)
    run('md5 requirements.txt > .python/req.digest', shell=True)
  os.execvp('python', ['python', '-u', '-B', '-s', './cli.py'] + sys.argv[1:])

# All code after this line is executed in the .python virtual environment
from fire import Fire as _Fire
from pyutil.flutter import *
from pyutil.firebase import *
from pyutil.test import *

if __name__ == "__main__":
  _Fire()