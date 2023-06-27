# Workstation Usage Guide
Once a user is registered, s(he) will be able to deploy a desktop using the Apps Dashboard. 
The desktop will be the unique way to access the contents of datasets, AI frameworks and software libraries, 
and to manage (launch, monitor) batch processes (jobs) on the computational resources provided by CHAIMELEON.

There is a dedicated guide to access and explore datasets, 
and it includes the launching and monitoring of a batch process (job) with jobman:
https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu_python/application-examples/dataset-access-guide.ipynb

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
  OS: Ubuntu 22.04 with lxde (graphical desktop environment)
  Basic software and libraries: python 3.10, pip, opencv, keras, scipy, scikit-learn, scikit-image, matplotlib, pandas, numpy, pydicom, pillow, dicom2nifti, simpleitk, h5py, nibabel.
  AI Frameworks: TensorFlow, PyTorch
  Development environment and other tools: JupyterNotebooks, Itk-snap, vim, poetry
  Container Engine: uDocker

## Special directories
There are three important directories in the remote desktop and also in jobs (they will be always in the same paths):
  - `/home/chaimeleon/datasets`
    All the datasets you selected to work with. 
    There is a read-only directory for each and labelled with its Persistent Unique Identifier (PID) in CHAIMELEON.
    More details of how they are organized in the [dataset access guide](https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu_python/application-examples/dataset-access-guide.ipynb).
    
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

## Software packages installation. 
On the other hand, you can upload your own files (e.g. source code, software packages) to the desktop. 
So you can install any package you miss, but as a normal user (you don't have root privileges in the remote desktop).
To automate the installation of your tools on every desktop created or job launched, 
you can upload all the installation packages to somewhere in the persistent directory 
(for example: `~/persistent-home/my-tools/`) and write down the commands to install them in the script `~/persistent-home/init.sh`. 
You will find a default init.sh file in your persistent-home with some examples to install your own tools/packages.
That script will be executed automatically at the beginning of the execution of every desktop or job created.

## Hardware resources
Each desktop has 1 core and 8 GB of RAM. The system can automatically increase to 2 cores if there are available resources.
Those are intentionally small resources to allow more people to create a desktop to connect to the platform. 
The idea is just use it for interactive applications and testing/debuging your algorithms. 
Once you need to launch the execution on the overall dataset (or using a GPU) you should launch a batch job with the "jobman" command (see below).

## Jobman client tool 
CHAIMELEON provides a command line tool named jobman specifically designed to manage batch processes (jobs). 
This tool allows the efficient distribution of the computational resources available in CHAIMELEON by launching the workloads as jobs managed by Kubernetes. 
Each desktop has jobman available as a command. There is an example of use at the end of the [dataset access guide](https://github.com/chaimeleon-eu/workstation-images/blob/main/ubuntu_python/application-examples/dataset-access-guide.ipynb)
