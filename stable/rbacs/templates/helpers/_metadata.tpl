{{- define "helpers.developer.role.name" -}}
{{- printf "%s-%s-role" "devs" (default "prod" .Values.clusterStage) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
