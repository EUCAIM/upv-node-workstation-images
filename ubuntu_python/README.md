# ubuntu-python

## Description
A basic image with ubuntu 22.04, python 3.10.6 and a few other useful tools/libraries like pandas, pydicom.  
The tags ending with `cuda11` includes also the CUDA toolkit/libraries.

## Usage
Put the command you want to execute after the `--` in the `jobman submit` command.  
Examples:  
  `jobman submit -i ubuntu-python:3.2 -- ls -l persistent-home/`  
  `jobman submit -i ubuntu-python:3.2cuda11 -e -- nvidia-smi`  
  `jobman submit -i ubuntu-python:3.2 -- python3 application-examples/list-all-dcm-files.py datasets/dc0dbf84-ebcf-470a-8b45-ef682ddafc6c`  
  `jobman submit -i ubuntu-python:3.2 -- python3 application-examples/filter-series-by-orientation.py datasets/dc0dbf84-ebcf-470a-8b45-ef682ddafc6c Z_SAGITTAL persistent-home/index-prostate-sagittal.json`

## License
https://github.com/chaimeleon-eu/workstation-images/blob/main/LICENSE
