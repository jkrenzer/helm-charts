{{- define "common-library.configMap.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.configMap -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: ConfigMap
metadata: {{ $metadata | nindent 2 }}
data: {}
{{- end -}}
{{- define "common-library.configMap" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.configMap.tpl")) -}}
{{- end -}}