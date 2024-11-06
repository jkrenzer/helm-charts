{{- define "common-library.deployment.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.deployment -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
{{- $locals   := .Values.pod -}}
{{- $podMetadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: apps/v1
kind: Deployment
metadata: {{ $metadata | nindent 2 }}
spec:
  replicas: {{ .Values.deployment.replicas }}
  selector:
    matchLabels: {{ mustMerge .Values.pod.labels .Values.common.labels | toYaml | nindent 6 }}
  template:
    metadata: {{ $podMetadata | nindent 6 }}
    spec: {}
{{- end -}}
{{- define "common-library.deployment" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.deployment.tpl")) -}}
{{- end -}}