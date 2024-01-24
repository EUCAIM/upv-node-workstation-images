# Workstation Usage Guide
Once a user is registered, s(he) will be able to deploy a desktop using the Apps Dashboard. 
The desktop will be the unique way to access the contents of datasets, AI frameworks and software libraries, 
and to manage (launch, monitor) batch processes (jobs) on the computational resources provided by CHAIMELEON.

There is a dedicated guide to access and explore datasets, 
and it includes the launching and monitoring of a batch process (job) with jobman:
https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu-python/rootfs/home/chaimeleon/application-examples/dataset-access-guide.ipynb

## Deployment and deletion of desktops
You can deploy and delete a desktop in the CHAIMELEON platform as many times as you considers. 
Each deployment using one or more datesets will be logged in the Tracer Service.
But you can have only one active desktop at a time. 
A desktop may be removed automatically if you don't connect to it for more than 7 days.
The steps to deploy a desktop can be seen in [this video](https://drive.google.com/file/d/1KQxLBEtO_iw08JlfNtDZdKgICZJ2RD_N).

## Once in the remote desktop
To show/hide the Guacamole menu: CTRL+SHIFT+ALT

You can upload files using this menu or simply drag and drop on the browser window. 
You will find the files uploaded in the home directory (/home/chaimeleon).

The Guacamole menu also allows you to manage the remote clipboard (if you use Chrome you can simply allow the synchronization of the clipboard),
the input method for keybloard and mouse, to adjust the zoom and disconect from the remote desktop.

### Software resources. 
Each desktop has installed the following software:  
  - OS: Ubuntu 22.04 with lxde (graphical desktop environment)  
  - Basic software and libraries: python 3.10, pip, opencv, keras, scipy, scikit-learn, scikit-image, matplotlib, pandas, numpy, pydicom, pillow, dicom2nifti, simpleitk, h5py, nibabel.  
  - AI Frameworks: TensorFlow, PyTorch  
  - Development environment and other tools: JupyterNotebooks, Itk-snap, vim, poetry  
  - Container Engine: uDocker

## Special directories
There are three important directories in the remote desktop and also in jobs (they will be always in the same paths):
  - `/home/chaimeleon/datasets`  
    All the datasets you selected to work with.  
    There is a read-only directory for each and labelled with its Persistent Unique Identifier (PID) in CHAIMELEON.  
    More details of how they are organized in the [dataset access guide](https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu-python/rootfs/home/chaimeleon/application-examples/dataset-access-guide.ipynb).
    
  - `/home/chaimeleon/persistent-home`  
    Private persistent storage: for your algorithms, results and whatever you need for the work.  
    If the desktop is deleted and redeployed afterwards, this folder persists and is remounted on the new instance.  
    On the other hand the access to files in it is a bit slower, so you should use the normal home (`/home/chaimeleon`) or `/tmp/` for temporal files if you want your algorithm/workflow go faster.
    
  - `/home/chaimeleon/shared-folder`  
    Public persistent storage where you can share files with the other CHAIMELEON users.

## Data download/upload disabled 
Network connectivity is strongly restricted within the CHAIMELEON platform due to the project general requirement to not allow the medical data to go out.
Applications running in the CHAIMELEON platform do not allow downloading/uploading data from/to external sources (from Internet), 
only there is connectivity to services running within the platform.

## Software packages and dependency libraries installation
There are two methods to satisfy the dependencies of your training algorithm or to make available in the CHAIMELEON platform any tool you need but not currently available: 
  - You can upload the package and install it as a normal user.
  - You can build a docker image locally, upload the image file and then run it with uDocker.
  
The two options are detailed in the next two chapters.

### Upload software package and autoinstall
You can upload your own files (e.g. source code, software packages, dependency libraries, models, etc.) to the desktop. 
That way you can install any package you miss, but only as a normal user (you don't have root privileges in the remote desktop).
If your required software package needs to be installed as root, then use the uDocker method (see the next chapter).

To automate the installation of your tools on every desktop created or job launched, 
you can upload all the installation packages to somewhere in the persistent-home directory 
(for example: `~/persistent-home/my-tools/`) and write down the commands to install them in the script `~/persistent-home/init.sh`.  
You will find a default init.sh file in your persistent-home with some examples to install your own tools/packages.  
That script will be executed automatically at the beginning of the execution of every desktop or job created.

### Running an image with uDocker
You can embed your algorithm and all its dependencies in a docker image, upload it to your desktop and then run it with uDocker.  
Once uploaded the image as a tar.gz file you will need to load it and then run. This is an example of how to do that with an alpine image:
```
udocker load -i ~/persistent-home/alpine-3.9.tar.gz
udocker run alpine:3.9 echo hello
```
Usually you will want to run that in a job (with more resources than the desktop) so this is how you can do that:
```
jobman submit -- "bash -c \"udocker load -i ~/persistent-home/alpine-3.9.tar.gz && udocker run alpine:3.9 echo hello\""
```
For more details of `jobman` command see the chapter [Jobman client tool](#jobman-client-tool).

## Hardware resources
Each desktop has 1 core and 8 GB of RAM. The system can automatically increase to 2 cores if there are available resources.
Those are intentionally small resources to allow more people to create a desktop to connect to the platform. 
The idea is just use it for interactive applications and testing/debuging your algorithms. 
Once you need to launch the execution on the overall dataset (or using a GPU) you should launch a batch job with the "jobman" command (see below).

## Jobman client tool 
CHAIMELEON provides a command line tool named "jobman" specifically designed to manage batch processes (jobs). 
This tool allows the efficient distribution of the computational resources available in CHAIMELEON by launching the workloads as jobs managed by Kubernetes. 
Each desktop has `jobman` available as a command. 
There is an example of use at the end of the [dataset access guide](https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu-python/rootfs/home/chaimeleon/application-examples/dataset-access-guide.ipynb).

Jobman gives access to 21 advanced computational resources that are organized in a queue. 
There are four types of resources and are labeled as `small-gpu`, `medium-gpu`, `large-gpu` and `no-gpu`. 
The features of these resource types are the following*:
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
 - Each user can only have one batch job active (waiting in the queue or running). 
   As an example, if a user launches a job as small-gpu, s(he) won’t be able to launch another one (no-gpu, small-gpu, medium-gpu or large-gpu) until that job ends or (s)he deletes it.
 - If a user launches a type of batch job and all resources of this type are busy, the job will wait for its execution in the queue until the previous launched jobs targeting the same resource type ends. 
   Both waiting and running are considered active batch jobs.  
   As an example, if a user launches a batch job targeting a large-gpu resource, and there are 5 large-gpu jobs running at this moment, 
   the new job will be enqueued and considered active until one large-gpu resource is released.
 - Resources used by jobs launched by jobman are independent of those assigned to the desktops. 
   Thus, a participant can always employ his/her respective desktop for executing processes locally without launching through jobman, even if s(he) already has an active batch job launched with jobman.

