{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "desktop-pytorch.chartName" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "desktop-pytorch.fullname" -}}
{{- if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "desktop-pytorch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "desktop-pytorch.labels" -}}
helm.sh/chart: {{ include "desktop-pytorch.chart" . }}
{{ include "desktop-pytorch.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/app-version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "desktop-pytorch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "desktop-pytorch.chartName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "desktop-pytorch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "desktop-pytorch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
{{- define "desktop-pytorch.container-password" -}}
{{- if .Release.IsInstall }}
{{- randAlphaNum 20 -}}
{{ else }}
{{- index (lookup "v1" "Secret" .Release.Namespace "{{ include "desktop-pytorch.fullname" . }}").data "container-password" -}}
{{- end }}
{{- end }}

{{- define "desktop-pytorch.id" -}}
{{- if .Release.IsInstall }}
{{- randAlphaNum 20 | b64enc -}}
{{ else }}
{{- index (lookup "v1" "Secret" .Release.Namespace "{{ include "desktop-pytorch.fullname" . }}").data "container-password" -}}
{{- end }}
{{- end }}
*/}}



{{/*
Print the name for the Guacamole connection.
*/}}
{{- define "desktop-pytorch.connectionName" -}}
DATE-TIME---{{ include "desktop-pytorch.fullname" . -}}
{{- end }}

{{/* Print a random string (useful for generate passwords). */}}
{{- define "utils.randomString" -}}
{{- randAlphaNum 20 -}}
{{- end }}

