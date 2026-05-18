{{/* vim: set filetype=mustache: */}}
{{- define "notification.name" -}}
{{- default "notification" .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "notification.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "notification" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "notification.chart" -}}
{{- printf "%s-%s" "notification" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "notification.labels" -}}
helm.sh/chart: {{ include "notification.chart" . }}
{{ include "notification.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "notification.selectorLabels" -}}
app.kubernetes.io/name: {{ include "notification.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: service
app.kubernetes.io/owner: retail-store-sample
{{- end }}

{{- define "notification.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "notification.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "notification.configMapName" -}}
{{- if .Values.configMap.create }}
{{- default (include "notification.fullname" .) .Values.configMap.name }}
{{- else }}
{{- default "default" .Values.configMap.name }}
{{- end }}
{{- end }}

{{- define "notification.podAnnotations" -}}
{{- if or .Values.metrics.enabled .Values.podAnnotations }}
{{- $podAnnotations := .Values.podAnnotations }}
{{- $metricsAnnotations := .Values.metrics.podAnnotations }}
{{- $allAnnotations := merge $podAnnotations $metricsAnnotations }}
{{- toYaml $allAnnotations }}
{{- end }}
{{- end -}}
