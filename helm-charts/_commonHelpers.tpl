{{/* vim: set filetype=mustache: */}}

{{- define "platform.annotations.tool_info" -}}
chaimeleon.eu/toolName: "{{ .Chart.Name }}"
chaimeleon.eu/toolVersion: "{{ .Chart.Version }}"
{{- end }}

{{- define "platform.annotations.mount_datasets" -}}
{{- if .Values.datasets_list }}
chaimeleon.eu/datasetsIDs: "{{ .Values.datasets_list }}"
chaimeleon.eu/datasetsMountPoint: "{{ include "platform.datasets.mount_point" . }}"
{{- end }}
{{- end }}

{{- define "platform.annotations.mount_persistent_home_and_shared" -}}
chaimeleon.eu/persistentHomeMountPoint: "{{ include "platform.persistent_home.mount_point" . }}"
chaimeleon.eu/persistentSharedFolderMountPoint: "{{ include "platform.persistent_shared_folder.mount_point" . }}"
{{- end }}

{{- define "platform.annotations.desktop_connection" -}}
chaimeleon.eu/createGuacamoleConnection: "true"
{{- end }}


{{/* Generate annotations for a deployment with graphical desktop and access to datasets. */}}
{{- define "platform.annotations" -}}
{{ include "platform.annotations.tool_info" . }}
{{/* Enable the mounting of datasets: */}}
{{ include "platform.annotations.mount_datasets" . }}
{{/* Enable the mounting of persistent-home and persistent-shared-folder: */}}
{{ include "platform.annotations.mount_persistent_home_and_shared" . }}
{{/* Enable the creation of a connection in Guacamole in order to access to the remote desktop: */}}
{{ include "platform.annotations.desktop_connection" . }}
{{- end }}


{{- define "platform.datalake.mount_point" -}}
/mnt/datalake
{{- end }}

{{- define "platform.persistent_home.mount_point" -}}
/home/ds/persistent-home
{{- end }}

{{- define "platform.persistent_shared_folder.mount_point" -}}
/home/ds/persistent-shared-folder
{{- end }}

{{- define "platform.datasets.mount_point" -}}
/home/ds/datasets
{{- end }}


{{/* Obtain the host part of the URL of a web application to be deployed in the platform. */}}
{{- define "platform.host" -}}
eucaim-node.i3m.upv.es
{{- end -}}


{{/* Obtain the url of the platform's image library. */}}
{{- define "platform.library-url" -}}
harbor.eucaim-node.i3m.upv.es:5000/library
{{- end -}}

{{/* Obtain the url of the platform's public image library. */}}
{{- define "platform.public-library-url" -}}
harbor.eucaim-node.i3m.upv.es/library-public
{{- end -}}

{{/* Obtain the url of the platform's dockerhub proxy. */}}
{{- define "platform.dockerhub-proxy" -}}
harbor.eucaim-node.i3m.upv.es/dockerhub
{{- end -}}

{{/* Obtain url of the platform's guacamole service, where the connection is created 
     (if requested by the annotation, i.e. included platform.annotations.desktop_connection). */}}
{{- define "platform.guacamole-url" -}}
https://eucaim-node.i3m.upv.es/guacamole/
{{- end -}}

