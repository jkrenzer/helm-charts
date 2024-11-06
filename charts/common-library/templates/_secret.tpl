{{- define "common-library.secret.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.secret -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: Secret
metadata: {{ $metadata | nindent 2 }}
data: {}
{{- end -}}
{{- define "common-library.secret" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.secret.tpl")) -}}
{{- end -}}