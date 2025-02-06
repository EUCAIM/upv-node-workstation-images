# Workstation Usage Guide
Once a user is registered, s(he) will be able to deploy a desktop using the Apps Dashboard. 
The desktop will be the unique way to access the contents of datasets, AI frameworks and software libraries, 
and to manage (launch, monitor) batch processes (jobs) on the computational resources provided by the platform.

## Deployment and deletion of desktops
In [this video](https://drive.google.com/file/d/1KQxLBEtO_iw08JlfNtDZdKgICZJ2RD_N) you can see a short demo of deployment of a desktop.

To deploy a desktop or whatever interactive application you should go to the green buton at the top right side and open the "Apps Dashboard".

![Go to apps dashboard](usage-guide-other/img/go-to-apps-dashboard.png)

In the Apps Dashboard you should ensure your namespace is selected in "Current context" at top right side: it should be `user-<yourUserName>`.

![Select namespace and catalog](usage-guide-other/img/select-namespace-and-catalog.png)

Now you can go to the "Catalog" and deploy a workstation in the platform. 
The most common are those that start with "desktop-" and "jupyter-".  
NOTE: if it is your first time, we recommend to select one with "jupyter" 
because you will be able to open the "dataset access guide" notebook directly in the remote desktop to execute the python code step by step
as we will see in the next chapter.

When deploying, just put some name and the id of dataset (or datasets) you are going to work with:

![Deployment params](usage-guide-other/img/deployment-params.png)

You can leave the "Dataset list" empty if you don't require one today in your work session.  

Alternatively you can search for the dataset you want to access in the initial web page, 
then click on "More" to go to the details, dropdown "Actions" and you will see the item "Use on Apps Dashboard".
This way the "Dataset list" field will be filled automatically.

Finally, when you push the "DEPLOY" button your desktop/application will be allocated in the platform. 
Usually it takes few seconds, but depending on demand up to a minute. 
If it takes more than that is because there are not enough free resources in the platform. You can delete other desktop you have deployed previously, if any, or just wait.  
When the deployment is "Ready" with one or more pods, read carefully the "Installation Notes":
you can go to the guacamole link and there you will see the connection to your desktop.

![Deployment ready and access link](usage-guide-other/img/deployment-ready-and-access-link.png)

You can deploy and delete a desktop in the platform as many times as you consider. 
Each deployment using one or more datasets will be logged in the Tracer Service.  
At the end of your work session please ensure you save your work in the persistent-home directory and consider to shutdown the desktop:

![Close session](usage-guide-other/img/close-session.png)

That way the resources will be released (desktop removed) and so other users (or yourself later) will be able to deploy a desktop.  
If you don't do it, keep in mind the desktop may be removed automatically if you don't connect to it for more than 7 days.

## Once in the remote desktop
To show/hide the Guacamole menu: CTRL+SHIFT+ALT

You can upload files using this menu or simply drag and drop on the browser window. 
You will find the files uploaded in the home directory (/home/ds).

The Guacamole menu also allows you to manage the remote clipboard (if you use Chrome you can simply allow the synchronization of the clipboard),
the input method for keyboard and mouse, to adjust the zoom and disconect from the remote desktop.

You can see the complete user manual of this tool here: https://guacamole.apache.org/doc/gug/using-guacamole.html

### Downloads from remote desktop
Any type of download from remote desktop is disabled, whether files or even text from clipboard. 
This is a project restriction agreed by the consortium to prevent take data (medical images or clinical data) out of platform. 
Only results like AI models or tools developed, once trained with the datasets in the platform, can be extracted upon prior request.  
So, taking this into account, the normal workflow is to develop your algorithm as much as possible in your local computer, 
then upload just to test or train with the platform datasets and finally request for download the trained model if you want. 
That model may be scanned and analysed by human or automated tools to ensure no dataset nor part of it is contained.

### Software resources. 
Each desktop has installed the following software:  
  - OS: Ubuntu 22.04 with lxde (graphical desktop environment)  
  - Basic software and libraries: python 3.10, pip, opencv, keras, scipy, scikit-learn, scikit-image, matplotlib, pandas, numpy, pydicom, pillow, dicom2nifti, simpleitk, h5py, nibabel.  
  - AI Frameworks: TensorFlow, PyTorch  
  - Development environment and other tools: JupyterNotebooks, Itk-snap, vim, poetry  
  - Container Engine: uDocker

Other tools/libraries available to install from persistent-shared-folder (see [Special directories](#special-directories)):
  - Development environment: VSCode
  - Python packages: catboost, lifelines, pyradiomics, pywavelets

### There is no Internet access
Things like "apt get", "git clone", "wget", "curl" or any access to a web page or service out of the platform will fail\*.  
Network connectivity to outside is strongly restricted in the platform environment due to the project general requirement to not allow the medical data to go out.
Applications running in the platform do not allow downloading/uploading data from/to external sources (from Internet), 
only there is connectivity to services running within the platform.

\* As an exception you can do "pip install" if you use the index provided by the PyPi mirror in the platform.  
If you need to install something see the chapter "[Software packages and dependency libraries installation](#software-packages-and-dependency-libraries-installation)".

### Explore the contents of a dataset
There is a dedicated guide of how to access and explore the contents of datasets, 
and it includes the launching and monitoring of a batch process (job) with jobman:  
[dataset access guide](ubuntu-python/rootfs/home/ds/application-examples/dataset-access-guide.ipynb).

It is in Jupyter Notebook format, Github prints it very well, 
but you can open it directly in the remote desktop to test the dataset access by yourself executing the python code in situ.
Just ensure you deployed a "jupyter" type desktop, open Jupyter Notebook (there is a desktop shortcut), 
go to `application-examples` (in `home` directory) and open `dataset-access-guide.ipynb`.

## Special directories
There are two important directories in the remote desktop and also in jobs (they will be always in the same paths):
  - `/home/ds/datasets`  
    All the datasets you selected to work with.  
    There is a read-only directory for each and labelled with its ID in the platform (the same as in the Dataset-explorer web page).  
    More details of how they are organized in the 
    [dataset access guide](ubuntu-python/rootfs/home/ds/application-examples/dataset-access-guide.ipynb).
    
  - `/home/ds/persistent-home`  
    Private persistent storage: for your algorithms, results and whatever you want to save.  
    If the desktop is deleted and redeployed afterwards, this folder persists and is remounted on the new instance.  
    On the other hand the access to files in it is a bit slower, 
    so you should use the normal home (`/home/ds`) or `/tmp/` for temporal files if you want your algorithm/workflow go faster.

Other useful directories:
  - `/home/ds/persistent-shared-folder`  
    Public persistent storage where you can share files with the other users in the platform
    and you will find other useful resources here like documentation, applications, container images 
    and python packages (from pypi.org which you can install with `pip`, see the "example 5" in `~/persistent-home/init.sh`). 
  
  - `/home/ds/application-examples`  
    Here you can find some simple application examples including the dataset access guide.

## Software packages and dependency libraries installation
There are some methods to satisfy the dependencies of your training algorithm or to get any tool you need in the remote desktop or your jobs in the platform: 
  - You can upload any package and install it as a normal user (not sudo/root).
  - For standard python packages you can use `pip install ...`, again as a normal user (not sudo/root).
  - You can build a docker image locally (in your personal computer) with all the required dependencies, upload the image file and then run it in the platform with uDocker.
  
All that options are detailed in the next chapters.  

### Upload software packages
You can [upload](#once-in-the-remote-desktop) your own files (e.g. source code, software packages, dependency libraries, models, etc.) to the remote desktop. 
Usually you want to put all the your uploaded packages to somewhere in the persistent-home directory (for example: `~/persistent-home/my-tools/`).

That way you can install any package you miss, but only as a normal user (you don't have root privileges in the remote desktop nor in jobs).
If your required software package needs to be installed as root, then use the uDocker method (see the next chapter [Running an image with uDocker](#running-an-image-with-udocker)).

### Install packages with pip
As the most common packages required in the AI development are python packages, a PyPi mirror has been deployed in the platform 
and so you can install any popular python package with `pip install ...`.

The general images in the platform provided by UPV are already configured to use the mirror, 
but if you need to install some additional package in a specific application image or your own custom image you will have to configure pip to use that mirror in the platform:
```
mkdir -p $HOME/.config/pip
echo '[global]
index-url=http://py-repo-service.package-repos-proxy:3141/root/pypi/+simple/
trusted-host=py-repo-service.package-repos-proxy' >> $HOME/.config/pip/pip.conf
```

### Automate installations
You can automate the installation of your tools/libraries on every desktop created or job launched.
Whether you uploaded the packages to your persistent-home (for example in: `~/persistent-home/my-tools/`) and they require some installation 
or you want to directly download and install a popular python package with pip, 
all you need is to write down the commands to install them in the script `~/persistent-home/init.sh`.  
You will find a default init.sh file in your persistent-home with some examples to install your own tools/packages.  
That script will be executed automatically at the beginning of the execution of every desktop or job created in the platform.

Take into account that, as there is no Internet access, you will need to upload the package you require but also all the dependencies if they are not installed with pip.

### Upload and install source code python packages
Some python packages are distributed as source code, usually when the extension of file is `.tar.gz` instead of `.whl`.  
In that cases, once downloaded the source code package, pip will compile it to generate the binary files. 
But it can require other dependecies in that step which may not be satisfied in the remote system (desktop or job) and the compilation can be time-consuming and resouce-intensive process.
So in that special cases may be better to build the wheel with the binaries (the .whl file) locally 
and then upload it to the platform ready to directly install.

[Here](usage-guide-other/upload-and-install-source-code-python-packages.md) you can find a practical use case in which the package "pyradiomics" (distributed as source code) is installed.

### Running an image with uDocker
Finally this is the last way to install software packages and dependencies.
This is specially useful when:
 - you need to install something (your algorithm or any tool or dependency) as root
 - you need to install a lot of dependencies and subdependencies which are hard to install (e.g. apt packages)
 - you are developing a platform application and you want to test your image before release
You can embed your algorithm and all its dependencies in a container image, upload it to your remote desktop and then run it with uDocker.
Let's see it step by step.

First you must "containerize" (aka "dockerize") your application. 
If you don't know what's that, you can start here: https://docs.docker.com/get-started/.
Basically you should write a dockerfile and do `docker build -t myApp:1.0 .` within the directory where the Dockerfile is.

For this example, we are going to pull an image already built with: `docker pull alpine:3.20`

Whether we have pulled an image or built our own, now we have the image in our docker local repository, and we can save it to a file with:
```
docker save alpine:3.20 -o alpine-3.20.tar.gz
```
And then we can upload the tar.gz file to the remote desktop, just drag and drop in the browser window 
and at the end of transfer it will be available in the home directory of the remote desktop. 
You should move to the persistent-home to make it available to all your desktops and jobs.  
In order to use the image, first it has to be loaded, and then you can run it:
```
udocker load -i ~/persistent-home/alpine-3.20.tar.gz alpine
udocker run --rm alpine:3.20 echo hello
```
You probably want to access to the datasets directory and to your persistent home to write results.
In that case you should mount those directories with `-v`:
```
udocker run --rm -v /home/ds/persistent-home -v /home/ds/datasets -v /mnt/datalake \
            alpine:3.20 ls -lh /home/ds/persistent-home
```
Note when the `datasets` directory is mounted, the `datalake` directory must be mounted also in order to provide destination to the symlinks.

At the end, usually you will want to run that in a job (with more resources than the desktop) so this is how you can do that with jobman:
```
jobman submit -- "udocker load -i ~/persistent-home/alpine-3.20.tar.gz alpine \
                  && udocker run --rm -v /home/ds/persistent-home -v /home/ds/datasets -v /mnt/datalake \
                             alpine:3.20 ls -lh /home/ds/persistent-home"
```
For more details of `jobman` command see the chapter [Jobman client tool](#jobman-client-tool).

And if you want to run a job with GPU resources you must add the "-r" argument with the resource flavor you want (for example `small-gpu`) 
and use for the host container one of the images with GPU libraries, i.e. with the tag `latest-cuda`:
```
jobman submit -r small-gpu -i ubuntu-python:latest-cuda -- \
    "udocker load -i ~/persistent-home/nvidia-cuda-11.8.0-runtime-ubuntu22.04.tar.gz nvidia/cuda \
     && udocker run --rm -v /home/ds/persistent-home -v /home/ds/datasets -v /mnt/datalake \
     nvidia/cuda:11.8.0-runtime-ubuntu22.04 nvidia-smi"
```
For more details of available resource flavors see the chapter [Resources flavors](#resources-flavors).  
Note for this last example we use a custom image based on the official nvidia/cuda:11.8.0-runtime-ubuntu22.04, 
and just adding the missing apt package "nvidia-utils-525" in order to make available the command `nvidia-smi`
(it's a simple dockerfile you can see [here](usage-guide-other/Dockerfile-custom-image-based-on-nvidia-cuda)).


## Hardware resources
Each desktop has 1 core and 8 GB of RAM. The system can automatically increase to 2 cores if there are available resources.
Those are intentionally small resources to allow more people to create a desktop to connect to the platform. 
The idea is just use it for interactive applications and testing/debuging your algorithms. 
Once you need to launch the execution on the overall dataset (or using a GPU) you should launch a batch job with the "jobman" command (see below).

## Jobman client tool 
All desktops in the platform provides the command `jobman` specifically designed to manage batch processes (jobs). 
This tool allows the efficient distribution of the computational resources available in the platform by launching the workloads as jobs managed by Kubernetes. 
There is a basic example of use at the end of the [dataset access guide](ubuntu-python/rootfs/home/ds/application-examples/dataset-access-guide.ipynb).

You can always see some usage examples executing the command without arguments:
```
$ jobman
jobman version '1.3.14-BETA'
Checkout jobman source code, releases, and documentation at: https://github.com/chaimeleon-eu/jobman

Usage examples:

      jobman images
      jobman image-details -i ubuntu-python
      jobman submit -i ubuntu-python -j job1 -r no-gpu -- python persistent-home/myScript.py
      jobman list
      jobman logs -j job1
      jobman delete -j job1
      jobman submit -i ubuntu-python:latest-cuda -r small-gpu -- nvidia-smi

Type jobman --help to see a  list of supported commands and more.
```

The first examples are shown in the dataset access guide.  
The last example is to submit a job with the `ubuntu-python` image, using the `latest-cuda` version 
(important if you want the cuda libraries and tools are included in order to use the GPU) and using the resources flavor (`-r` argument) `small-gpu`.  
All the resources flavors are detailed in the next chapter.

### Resources flavors
Jobman gives access to 21 advanced computational resources that are organized in a queue.  
There are four types of resources and are labeled as `small-gpu`, `medium-gpu`, `large-gpu` and `no-gpu`. 
These are the resources flavors, and the features of each of these are the following*:
 - `small-gpu`  
   This queue provides 8 resources. Thus, it can execute 8 batch jobs concurrently (from different users).  
   Each resource has 4 cores, 32 GB RAM and a GPU Nvidia A30 with 6 GB.  
   In this queue, the time limit for each batch job is 16 hours. If the job is not done within this time, it will be automatically deleted.
 - `medium-gpu`  
   This queue provides 4 resources. Thus, it can execute 4 batch jobs concurrently.  
   Each resource has 8 cores, 64 GB RAM and a GPU Nvidia A30 with 12 GB.  
   In this queue, the time limit for each batch job is 24 hours. If the job is not done within this time, it will be automatically deleted.
 - `large-gpu`  
   This queue provides 5 resources. Thus, it can execute 5 batch jobs concurrently.  
   Each resource has 8 cores, 64 GB RAM and a GPU Nvidia V100 with 32 GB.  
   In this queue, the time limit for each batch job is 24 hours. If the job is not done within this time, it will be automatically deleted.
 - `no-gpu`  
   This queue provides 4 resources. Thus, it can execute 4 batch jobs concurrently.  
   Each resource has 8 cores, 64 GB RAM without GPU.  
   In this queue, the time limit for each batch job is 8 hours. If the job is not done within this time, it will be automatically deleted.
           
\* This are rough numbers, we can change them anytime according to demand.

You can launch batch jobs from your desktop using the Jobman Client tool (jobman) at any time (24x7), taking into account the following points:
 - The queue of Jobman follows a First Input First Output (FIFO) policy by type of resource required.
 - If a user launches a type of batch job and all resources of this type are busy, the job will wait for its execution in the queue 
   until the previous launched jobs targeting the same resource type ends. 
   Both waiting and running are considered active batch jobs.  
   As an example, if a user launches a batch job targeting a large-gpu resource, and there are 5 large-gpu jobs running at this moment, 
   the new job will be enqueued (and considered active) until one large-gpu resource is released.
 - Resources used by jobs launched by jobman are independent of those assigned to the desktops. 

