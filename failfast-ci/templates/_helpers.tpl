{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "api-name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-api" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "worker-name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-worker" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "api-fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-api-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "worker-fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-worker-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
