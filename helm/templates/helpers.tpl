{{/*
Return the fullname of the chart
*/}}
{{- define "frontend-deploy.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
