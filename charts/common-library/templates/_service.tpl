{{- define "common-library.service.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.service -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: Service
metadata: {{ $metadata | nindent 2 }}
spec:
  ports: []
  selector: {{ tpl .Values.service.selectors . | nindent 4}}
{{- end -}}
{{- define "common-library.service" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.service.tpl")) -}}
{{- end -}}