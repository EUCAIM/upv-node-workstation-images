# ubuntu-python

## Description
An image with ubuntu 22.04, python 3.10.6, pytorch and a few other useful tools/libraries like pandas, pydicom.  
The tags ending with `cuda11` includes also the CUDA toolkit/libraries.

## Usage
Put the command you want to execute after the `--` in the `jobman submit` command.  
Examples:  
  `jobman submit -i ubuntu-python-pytorch:3.1 -- ls -l /home/chaimeleon/persistent-home/`  
  `jobman submit -i ubuntu-python-pytorch:3.1cuda11 -e -- nvidia-smi`  
  `jobman submit -i ubuntu-python-pytorch:3.1cuda11 -e -- python3 -c "import torch; torch.cuda.is_available()"`

## License
https://github.com/chaimeleon-eu/workstation-images/blob/main/LICENSE
