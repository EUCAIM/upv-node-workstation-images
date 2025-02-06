#### Upload and install python packages
Let's see an example of how to download the package "lifelines" with all its dependencies, then upload and install in the platform.

We use docker to run a container with the same python version of the platform (3.10), 
that way we will download packages compatible with the platform.
```
docker run --rm -it -v /tmp:/tmp/host-tmp python:3.10 bash
```
For Windows just change the temp directory path in the docker run command, like this:  
`docker run --rm -it -v c:\tmp:/tmp/host-tmp python:3.10 bash`

Once in the container, we download lifelines and all the dependencies:
```
root@e3d0287e10f3:/# mkdir /tmp/host-tmp/lifelines
root@e3d0287e10f3:/# cd /tmp/host-tmp/lifelines
root@e3d0287e10f3:/tmp/host-tmp/lifelines# pip download lifelines
Collecting lifelines
  Downloading lifelines-0.28.0-py3-none-any.whl (349 kB)
Collecting pandas>=1.2.0
  Downloading pandas-2.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (13.0 MB)
Collecting numpy<2.0,>=1.14.0
  Downloading numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (18.2 MB)
Collecting formulaic>=0.2.2
  Downloading formulaic-1.0.1-py3-none-any.whl (94 kB)
Collecting autograd-gamma>=0.3
  Downloading autograd-gamma-0.5.0.tar.gz (4.0 kB)
  Preparing metadata (setup.py) ... done
Collecting matplotlib>=3.0
  Downloading matplotlib-3.8.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.6 MB)
Collecting scipy>=1.2.0
  Downloading scipy-1.12.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (38.4 MB)
Collecting autograd>=1.5
  Downloading autograd-1.6.2-py3-none-any.whl (49 kB)
Collecting future>=0.15.2
  Downloading future-1.0.0-py3-none-any.whl (491 kB)
Collecting typing-extensions>=4.2.0
  Downloading typing_extensions-4.9.0-py3-none-any.whl (32 kB)
Collecting interface-meta>=1.2.0
  Downloading interface_meta-1.3.0-py3-none-any.whl (14 kB)
Collecting wrapt>=1.0
  Downloading wrapt-1.16.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (80 kB)
Collecting cycler>=0.10
  Downloading cycler-0.12.1-py3-none-any.whl (8.3 kB)
Collecting packaging>=20.0
  Downloading packaging-23.2-py3-none-any.whl (53 kB)
Collecting fonttools>=4.22.0
  Downloading fonttools-4.49.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.6 MB)
Collecting contourpy>=1.0.1
  Downloading contourpy-1.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (310 kB)
Collecting kiwisolver>=1.3.1
  Downloading kiwisolver-1.4.5-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl (1.6 MB)
Collecting pillow>=8
  Downloading pillow-10.2.0-cp310-cp310-manylinux_2_28_x86_64.whl (4.5 MB)
Collecting python-dateutil>=2.7
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
Collecting pyparsing>=2.3.1
  Downloading pyparsing-3.1.1-py3-none-any.whl (103 kB)
Collecting tzdata>=2022.7
  Downloading tzdata-2024.1-py2.py3-none-any.whl (345 kB)
Collecting pytz>=2020.1
  Downloading pytz-2024.1-py2.py3-none-any.whl (505 kB)
Collecting six>=1.5
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Saved ./lifelines-0.28.0-py3-none-any.whl
Saved ./autograd-1.6.2-py3-none-any.whl
Saved ./autograd-gamma-0.5.0.tar.gz
Saved ./formulaic-1.0.1-py3-none-any.whl
Saved ./matplotlib-3.8.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./pandas-2.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./scipy-1.12.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./contourpy-1.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./cycler-0.12.1-py3-none-any.whl
Saved ./fonttools-4.49.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./future-1.0.0-py3-none-any.whl
Saved ./interface_meta-1.3.0-py3-none-any.whl
Saved ./kiwisolver-1.4.5-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl
Saved ./packaging-23.2-py3-none-any.whl
Saved ./pillow-10.2.0-cp310-cp310-manylinux_2_28_x86_64.whl
Saved ./pyparsing-3.1.1-py3-none-any.whl
Saved ./python_dateutil-2.8.2-py2.py3-none-any.whl
Saved ./pytz-2024.1-py2.py3-none-any.whl
Saved ./typing_extensions-4.9.0-py3-none-any.whl
Saved ./tzdata-2024.1-py2.py3-none-any.whl
Saved ./wrapt-1.16.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl
Saved ./six-1.16.0-py2.py3-none-any.whl
Successfully downloaded lifelines autograd autograd-gamma formulaic matplotlib numpy pandas scipy contourpy cycler fonttools future interface-meta kiwisolver packaging pillow pyparsing python-dateutil pytz typing-extensions tzdata wrapt six
```
Now we can exit from the container (it will be deleted due to the arg `--rm` that we put previously) and see the result files which are in the temporal directory (that we created and mounted previously in the container):
```
root@e3d0287e10f3:/tmp/host-tmp/lifelines# exit
user1@host:~$ ls -lh /tmp/lifelines
total 91M
-rw-r--r-- 1 root root  49K Feb 22 18:22 autograd-1.6.2-py3-none-any.whl
-rw-r--r-- 1 root root 3.9K Feb 22 18:22 autograd-gamma-0.5.0.tar.gz
-rw-r--r-- 1 root root 304K Feb 22 18:22 contourpy-1.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root 8.2K Feb 22 18:22 cycler-0.12.1-py3-none-any.whl
-rw-r--r-- 1 root root 4.4M Feb 22 18:22 fonttools-4.49.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  92K Feb 22 18:22 formulaic-1.0.1-py3-none-any.whl
-rw-r--r-- 1 root root 480K Feb 22 18:22 future-1.0.0-py3-none-any.whl
-rw-r--r-- 1 root root  15K Feb 22 18:22 interface_meta-1.3.0-py3-none-any.whl
-rw-r--r-- 1 root root 1.6M Feb 22 18:22 kiwisolver-1.4.5-cp310-cp310-manylinux_2_12_x86_64.manylinux2010_x86_64.whl
-rw-r--r-- 1 root root 342K Feb 22 18:22 lifelines-0.28.0-py3-none-any.whl
-rw-r--r-- 1 root root  12M Feb 22 18:22 matplotlib-3.8.3-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  18M Feb 22 18:22 numpy-1.26.4-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  52K Feb 22 18:22 packaging-23.2-py3-none-any.whl
-rw-r--r-- 1 root root  13M Feb 22 18:22 pandas-2.2.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root 4.3M Feb 22 18:22 pillow-10.2.0-cp310-cp310-manylinux_2_28_x86_64.whl
-rw-r--r-- 1 root root 101K Feb 22 18:22 pyparsing-3.1.1-py3-none-any.whl
-rw-r--r-- 1 root root 242K Feb 22 18:22 python_dateutil-2.8.2-py2.py3-none-any.whl
-rw-r--r-- 1 root root 494K Feb 22 18:22 pytz-2024.1-py2.py3-none-any.whl
-rw-r--r-- 1 root root  37M Feb 22 18:22 scipy-1.12.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
-rw-r--r-- 1 root root  11K Feb 22 18:22 six-1.16.0-py2.py3-none-any.whl
-rw-r--r-- 1 root root  32K Feb 22 18:22 typing_extensions-4.9.0-py3-none-any.whl
-rw-r--r-- 1 root root 338K Feb 22 18:22 tzdata-2024.1-py2.py3-none-any.whl
-rw-r--r-- 1 root root  79K Feb 22 18:22 wrapt-1.16.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl
```
We should upload these file to our remote desktop in the platform, just drag and drop in the browser window 
and at the end of transference they will be available in the home directory of the remote desktop.  
Note a lot of packages are already installed in the platform (you can see with `pip list` in your remote desktop) 
the only strictly required in this case are autograd, autograd-gamma, formulaic, future and interface_meta
but if the packages are small and you want to be sure just upload all.

We should move to the persistent-home to make them available to all our desktops or jobs (we make a directory "my-tools" there for all our packages):
```
ds@jupyter-tensorflow-test-699949bf4-z2fv:~$ mkdir -p ~/persistent-home/my-tools
ds@jupyter-tensorflow-test-699949bf4-z2fv:~$ mv ~/*.whl ~/persistent-home/my-tools/
```
Now we can easily install lifelines with:
```
ds@jupyter-tensorflow-test-699949bf4-z2fv:~$ pip install --no-index --find-links ~/persistent-home/my-tools lifelines
```
And even we can add that same command line in our `init.sh` script to automatically install on every desktop or jobs that we launch in the platform:
```
ds@jupyter-tensorflow-test-699949bf4-z2fv:~$ echo 'pip install --no-index --find-links ~/persistent-home/my-tools lifelines' > ~/persistent-home/init.sh
```


