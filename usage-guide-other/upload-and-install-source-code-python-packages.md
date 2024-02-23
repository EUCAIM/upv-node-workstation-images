#### Build wheel to install a python package
Some python packages are distributed as source code, usually when the extension of file is `.tar.gz` instead of `.whl`.  
In that cases, once downloaded the source code package, pip will compile it to generate the binary files. 
But it can require other dependecies in that step which may not be satisfied in the platform.  
So our recommendations in case of source code packages is to build the wheel with the binaries (the .whl file) locally and then upload it to the platform ready to directly install, instead of upload the .tar.gz package and try to install that (which means compile there).

Let's see an example of how to generate the wheel for the package pyradiomics.

We use docker to run a container with the same python version of the platform (3.10), 
that way we will download packages and obtain wheels compatible with the platform.
```
docker run --rm -it -v /tmp:/tmp/host-tmp python:3.10 bash
```
For Windows just change the temp directory path in the docker run command, like this:  
`docker run --rm -it -v c:\tmp:/tmp/host-tmp python:3.10 bash`

Once in the container, in that case we have to install numpy, a dependency for build pyradiomics:
```
root@b7f0ff584ac2:/#pip install numpy
Collecting numpy
  Downloading numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (18.2 MB)
Installing collected packages: numpy
Successfully installed numpy-1.26.4
```
Now we download pyradiomics and all the dependencies:
```
root@b7f0ff584ac2:/# mkdir /tmp/host-tmp/pyradiomics
root@b7f0ff584ac2:/# cd /tmp/host-tmp/pyradiomics
root@b7f0ff584ac2:/tmp/host-tmp/pyradiomics# pip download pyradiomics
Collecting pyradiomics
  Downloading pyradiomics-3.0.1.tar.gz (34.5 MB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Installing backend dependencies ... done
  Preparing metadata (pyproject.toml) ... done
  Preparing metadata (setup.py) ... done
Collecting numpy>=1.9.2
  Using cached numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (18.2 MB)
Collecting SimpleITK>=0.9.1
  Downloading SimpleITK-2.3.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (52.7 MB)
Collecting PyWavelets>=0.4.0
  Downloading pywavelets-1.5.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.5 MB)
Collecting pykwalify>=1.6.0
  Downloading pykwalify-1.8.0-py2.py3-none-any.whl (24 kB)
Collecting six>=1.10.0
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting python-dateutil>=2.8.0
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
Collecting ruamel.yaml>=0.16.0
  Downloading ruamel.yaml-0.18.6-py3-none-any.whl (117 kB)
Collecting docopt>=0.6.2
  Downloading docopt-0.6.2.tar.gz (25 kB)
  Preparing metadata (setup.py) ... done
Collecting ruamel.yaml.clib>=0.2.7
  Downloading ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (526 kB)
Saved ./pyradiomics-3.0.1.tar.gz
Saved ./numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./pykwalify-1.8.0-py2.py3-none-any.whl
Saved ./pywavelets-1.5.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./SimpleITK-2.3.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./six-1.16.0-py2.py3-none-any.whl
Saved ./docopt-0.6.2.tar.gz
Saved ./python_dateutil-2.8.2-py2.py3-none-any.whl
Saved ./ruamel.yaml-0.18.6-py3-none-any.whl
Saved ./ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl
Successfully downloaded pyradiomics numpy pykwalify PyWavelets SimpleITK six docopt python-dateutil ruamel.yaml ruamel.yaml.clib
```
Finally we install to generate the wheel:
```
root@7ad713eee5a0:/tmp/host-tmp/pyradiomics# pip install pyradiomics
Collecting pyradiomics
  Using cached pyradiomics-3.0.1.tar.gz (34.5 MB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Installing backend dependencies ... done
  Preparing metadata (pyproject.toml) ... done
  Preparing metadata (setup.py) ... done
Requirement already satisfied: numpy>=1.9.2 in /usr/local/lib/python3.10/site-packages (from pyradiomics) (1.26.4)
Collecting SimpleITK>=0.9.1 (from pyradiomics)
  Using cached SimpleITK-2.3.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (7.9 kB)
Collecting PyWavelets>=0.4.0 (from pyradiomics)
  Using cached pywavelets-1.5.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (9.0 kB)
Collecting pykwalify>=1.6.0 (from pyradiomics)
  Using cached pykwalify-1.8.0-py2.py3-none-any.whl (24 kB)
Collecting six>=1.10.0 (from pyradiomics)
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting docopt>=0.6.2 (from pykwalify>=1.6.0->pyradiomics)
  Using cached docopt-0.6.2.tar.gz (25 kB)
  Preparing metadata (setup.py) ... done
Collecting python-dateutil>=2.8.0 (from pykwalify>=1.6.0->pyradiomics)
  Using cached python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
Collecting ruamel.yaml>=0.16.0 (from pykwalify>=1.6.0->pyradiomics)
  Using cached ruamel.yaml-0.18.6-py3-none-any.whl.metadata (23 kB)
Collecting ruamel.yaml.clib>=0.2.7 (from ruamel.yaml>=0.16.0->pykwalify>=1.6.0->pyradiomics)
  Using cached ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl.metadata (2.2 kB)
Using cached pywavelets-1.5.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.5 MB)
Using cached SimpleITK-2.3.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (52.7 MB)
Using cached ruamel.yaml-0.18.6-py3-none-any.whl (117 kB)
Using cached ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (526 kB)
Building wheels for collected packages: pyradiomics, docopt
  Building wheel for pyradiomics (setup.py) ... done
  Created wheel for pyradiomics: filename=pyradiomics-3.0.1-cp310-cp310-linux_x86_64.whl size=178055 sha256=59458f68486209b538a724c539ef45b03724574295f326a17a71cf223c807ada
  Stored in directory: /root/.cache/pip/wheels/91/c5/13/c5fd4c5ad3edf4062bb3855bd66fad25871c9c6dc0b3fda544
  Building wheel for docopt (setup.py) ... done
  Created wheel for docopt: filename=docopt-0.6.2-py2.py3-none-any.whl size=13707 sha256=c400e3b356e1473312e6886eb9d3240b2a4599e7a330a08be4b7f7cae3ddbb92
  Stored in directory: /root/.cache/pip/wheels/fc/ab/d4/5da2067ac95b36618c629a5f93f809425700506f72c9732fac
Successfully built pyradiomics docopt
Installing collected packages: SimpleITK, docopt, six, ruamel.yaml.clib, PyWavelets, ruamel.yaml, python-dateutil, pykwalify, pyradiomics
Successfully installed PyWavelets-1.5.0 SimpleITK-2.3.1 docopt-0.6.2 pykwalify-1.8.0 pyradiomics-3.0.1 python-dateutil-2.8.2 ruamel.yaml-0.18.6 ruamel.yaml.clib-0.2.8 six-1.16.0
```
The packages already downloaded and cached in the previus step are now used to install, 
and two wheels are generated in temporal directories for the two packages with source code (pyradiomics and the dependency docopt).

Let's move them to our working directory and remove the source code packages (no more needed):
```
root@7ad713eee5a0:/tmp/host-tmp/pyradiomics# mv /root/.cache/pip/wheels/91/c5/13/c5fd4c5ad3edf4062bb3855bd66fad25871c9c6dc0b3fda544/pyradiomics-3.0.1-cp310-cp310-linux_x86_64.whl .
root@7ad713eee5a0:/tmp/host-tmp/pyradiomics# mv /root/.cache/pip/wheels/fc/ab/d4/5da2067ac95b36618c629a5f93f809425700506f72c9732fac/docopt-0.6.2-py2.py3-none-any.whl .
root@7ad713eee5a0:/tmp/host-tmp/pyradiomics# rm pyradiomics-3.0.1.tar.gz docopt-0.6.2.tar.gz
```
Now we can exit from the container (it will be deleted due to the arg `--rm` that we put previously) and see the result files which are in the temporal directory (that we created and mounted previously in the container):
```
root@7ad713eee5a0:/tmp/host-tmp/pyradiomics# exit
user1@host:~$ ls -lh /tmp/pyradiomics
total 74M
-rw-r--r-- 1 root root  51M Feb 22 15:49 SimpleITK-2.3.1-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  14K Feb 22 15:51 docopt-0.6.2-py2.py3-none-any.whl
-rw-r--r-- 1 root root  18M Feb 22 15:49 numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  25K Feb 22 15:49 pykwalify-1.8.0-py2.py3-none-any.whl
-rw-r--r-- 1 root root 174K Feb 22 15:51 pyradiomics-3.0.1-cp310-cp310-linux_x86_64.whl
-rw-r--r-- 1 root root 242K Feb 22 15:49 python_dateutil-2.8.2-py2.py3-none-any.whl
-rw-r--r-- 1 root root 4.4M Feb 22 15:49 pywavelets-1.5.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root 116K Feb 22 15:49 ruamel.yaml-0.18.6-py3-none-any.whl
-rw-r--r-- 1 root root 515K Feb 22 15:49 ruamel.yaml.clib-0.2.8-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl
-rw-r--r-- 1 root root  11K Feb 22 15:49 six-1.16.0-py2.py3-none-any.whl
```
We should upload these file to our remote desktop in the platform, just drag and drop in the browser window 
and at the end of transference they will be available in the home directory of the remote desktop.  
Note the two biggest packages (SimpleITK and numpy) are already installed in the platform (you can see with `pip list` in your remote desktop) but if you want to be sure just upload all.

We should move to the persistent-home to make them available to all our desktops or jobs (we make a directory "my-tools" there for all our packages):
```
chaimeleon@jupyter-tensorflow-test-699949bf4-z2fv:~$ mkdir -p ~/persistent-home/my-tools
chaimeleon@jupyter-tensorflow-test-699949bf4-z2fv:~$ mv ~/*.whl ~/persistent-home/my-tools/
```
Now we can easily install pyradiomics with:
```
chaimeleon@jupyter-tensorflow-test-699949bf4-z2fv:~$ pip install --no-index --find-links ~/persistent-home/my-tools pyradiomics
```
And even we can add that same command line in our `init.sh` script to automatically install on every desktop or jobs that we launch in the platform:
```
chaimeleon@jupyter-tensorflow-test-699949bf4-z2fv:~$ echo 'pip install --no-index --find-links ~/persistent-home/my-tools pyradiomics' > ~/persistent-home/init.sh
```

