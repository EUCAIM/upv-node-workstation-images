{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "jupyter-pytorch.chartName" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jupyter-pytorch.fullname" -}}
{{- if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jupyter-pytorch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "jupyter-pytorch.labels" -}}
helm.sh/chart: {{ include "jupyter-pytorch.chart" . }}
{{ include "jupyter-pytorch.selectorLabels" . }}
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
{{- define "jupyter-pytorch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jupyter-pytorch.chartName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "jupyter-pytorch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jupyter-pytorch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
{{- define "jupyter-pytorch.container-password" -}}
{{- if .Release.IsInstall }}
{{- randAlphaNum 20 -}}
{{ else }}
{{- index (lookup "v1" "Secret" .Release.Namespace "{{ include "jupyter-pytorch.fullname" . }}").data "container-password" -}}
{{- end }}
{{- end }}

{{- define "jupyter-pytorch.id" -}}
{{- if .Release.IsInstall }}
{{- randAlphaNum 20 | b64enc -}}
{{ else }}
{{- index (lookup "v1" "Secret" .Release.Namespace "{{ include "jupyter-pytorch.fullname" . }}").data "container-password" -}}
{{- end }}
{{- end }}
*/}}


{{/*
Print the name for the Guacamole connection.
*/}}
{{- define "jupyter-pytorch.connectionName" -}}
DATE-TIME---{{ include "jupyter-pytorch.fullname" . -}}
{{- end }}

{{/* Print a random string (useful for generate passwords). */}}
{{- define "utils.randomString" -}}
{{- randAlphaNum 20 -}}
{{- end }}

