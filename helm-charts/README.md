
## How to design a workstation Helm chart for the platform

This is a guide to create a Helm chart for deploying a workstation in the platform. 
We recommend to take one of our charts as an example:
 - [helm-chart-desktop-tensorflow](helm-chart-desktop-tensorflow): if you want to create a chart of type desktop.
 - [helm-chart-jupyter-tensorflow](helm-chart-jupyter-tensorflow): if you want to create a chart of type web application.

### The `_commonHelpers.tpl`

We have write this helpers file as a library of common functions that you can use in your charts for the platform.
It makes you write less lines in the templates of your charts and also you don't have to know about common paths and configurations required.

To use it just copy the file into the "templates" directory of your chart:  
`cd templates && wget https://github.com/EUCAIM/upv-node-workstation-images/blob/main/helm-charts/_commonHelpers.tpl`  

It can be directly in the "templates" directory, beside your `_helpers.tpl` (if you have one) or in a subdirectory.  
All the functions defined in it have the prefix `platform.`, and they can be used with `include` 
(you will see in the next chapters of this guide).

### Images

First of all, the container images used in the chart must accomplish certain conditions, specifically those that mounts cephfs volumes.
Please check the 
[design guide for creating images for the platform](../README.md#how-to-design-a-workstation-image-for-the-platform).

Once uploaded to the images repository, you will be able to use an image with:
```yaml
    image: "{{ include "platform.library-url" . }}/ubuntu-python-tensorflow-desktop:{{ .Chart.AppVersion }}"
```
Or if the container don't mount cephfs volumes you can use a non-customized image from dockerHub with:
```yaml
    image: {{ include "platform.dockerhub-proxy" . }}/library/postgres:alpine3.16
```

### Annotations in the deployment

There should be a template in the helm chart for creating a deployment resource. 
The deployment usually should have this annotations:
```yaml
  annotations: 
    chaimeleon.eu/toolName: "{{ .Chart.Name }}"
    chaimeleon.eu/toolVersion: "{{ .Chart.Version }}"
    
    chaimeleon.eu/datasetsIDs: "{{ .Values.datasets_list }}"
    chaimeleon.eu/datasetsMountPoint: "{{ include "platform.datasets.mount_point" . }}"
    
    chaimeleon.eu/persistentHomeMountPoint: "{{ include "platform.persistent_home.mount_point" . }}"
    chaimeleon.eu/persistentSharedFolderMountPoint: "{{ include "platform.persistent_shared_folder.mount_point" . }}"
    
    chaimeleon.eu/createGuacamoleConnection: "true"
```
All this annotations are optional except `toolName` and `toolVersion`.  
If you want to add all of them, as usually, you can just call this function:
```yaml
  annotations: 
    {{- include "platform.annotations" . | nindent 4 }}
```

If you don't want to mount datasets, don't add `chaimeleon.eu/datasetsIDs` or set the value to empty string `""`.  
If you don't want to mount the persistent-home, don't add `chaimeleon.eu/persistentHomeMountPoint`.  
If you don't want to mount the persistent-shared-folder, don't add `chaimeleon.eu/persistentSharedFolderMountPoint`.

If the image don't include a desktop and you don't want to create a guacamole connection, don't add `chaimeleon.eu/createGuacamoleConnection`.  
Otherwise you must include a secret in your helm chart, with the same name as the deployment and containing two entries: `container-user` and `container-password`.  
Example:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: "{{ include "desktop-tensorflow.fullname" . }}"
type: Opaque
stringData:
  container-user: "ds"
  container-password: "{{ randAlphaNum 20 }}"
```

More details in the [k8s operator README](https://github.com/chaimeleon-eu/k8s-chaimeleon-operator#known-annotations-in-deployments-and-jobs).

This annotations will be read by the k8s operator before creating the deployment in order to do some stuff:
 - Check if the user have access to datasets selected (in case of success, the access will be granted including the gid in the ACL of dataset directories).
 - Mount datalake, datasets, persistent-home and persistent-shared-folder in the container.
 - Notify the use of datasets (with the tool name and version) to the Tracer Service.
 - Create a connection in Guacamole to allow the user to connect to the remote desktop.

### How to show the values to be set by the user as a form

The current interface for launch applications in the platform (Kubeapps) takes the file `values.schema.json` in the root dir of the chart 
to create a user friendly form with the values to configure the deployment.

We recommend to create this file including at least the field for the "dataset list". 
This is an example of the file `values.schema.json`:
```json
{
  "$schema": "http://json-schema.org/schema#",
  "type": "object",
  "properties": {
    "datasets_list": {
      "type": "string",
      "title": "Dataset list",
      "description": "A comma separated list of the datasets that will be available at the container. (It can be empty)",
      "form": true
    }
  }
}
```

### Automated by k8s operator
The following chapters contain details about certain aspects which are already solved by the k8s operator, 
so you don't have to worry about, don't have to add nothing in your chart, but they are kept for your information.

#### user and permissions (automatically added by the k8s operator, just FYI)

If there is any cephfs volume mounted, the main process of a container must be run by the user with **uid** 1000, **gid** 1000 
and a **supplemental group** assigned to the user when created.
The reason for that is that the cephfs volumes mounted in the container have file permissions configured for these user ids. 
Also this volumes can be mounted in many different workstations and the user IDs must be the same in all of them to ensure the user have the same rights on the same files. 
And of course the user can not be root because she/he only should be able to access her/his files and datasets.

The **uid** and **gid** are shared by all the users, they corresponds to an OS generic user (that we usually call "ds", contraction of data scientist), 
so the image designer can create that user and use it for setting the permissions on the container "native" files.  
The **supplemental group** is different for every user and the platform use it for setting the permissions on the files for him/her.
Specifically, the supplemental group of a user is included in the ACL (Access Control List) of files and directories that the user must have access to.

As a result, any deployment, statefulset or pod created by the chart will include the section `securityContext` with this content:
```yaml
      securityContext:
        runAsUser: 1000
        runAsGroup: 1000
        fsGroup: 1000
        supplementalGroups: [ <the user GID ]
```
But you don't need to add it in your helm chart, the k8s operator will do that. 

#### The priorityClass and request of resources (automatically added by the k8s operator)

You can specify the priority class with:  
`spec.template.spec.priorityClassName: processing-applications`.  
This is the default and currently the unique priority class defined for that type of deployments.

And finally you can specify the resources you expect to use for each container in `spec.template.spec.containers[i].resources`:
```yaml
        resources:
          requests:
            memory: "4Gi"
            cpu: "1"
```
Or let the user set them with:
```yaml
        resources:
          requests:
            memory: "{{ .Values.requests.memory }}"
            cpu: "{{ .Values.requests.cpu }}"
        {{- if .Values.requests.gpu }}
            nvidia.com/gpu: 1
          limits:
            nvidia.com/gpu: 1
        {{- end }}
```
The current maximum per user (actually per namespace) is defined [here](https://github.com/EUCAIM/k8s-deploy-node/blob/master/extra-configurations/resource-quotas/platform-users.yml).

The priority class and resources request affect the quality of service, 
go [here](https://github.com/EUCAIM/k8s-deploy-node/tree/master/extra-configurations#quality-of-service) if you want to know more.

## Check the chart
```
helm lint chartDirectory
```
Previsualise the result of rendering the chart locally:
```
helm --debug template chartDirectory
```

## Build the chart

```
helm package chartDirectory
```
This command generates a tgz package in the current directory which can be uploaded to any chart repository.

