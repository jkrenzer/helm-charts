{{- define "common-library.service.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.service -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: Service
metadata: 
  {{- $metadata | nindent 2 }}
spec:
  ports: 
    {{- include "common-library.service.ports" . | nindent 4 }}
  selector:
    {{- if kindIs "map" .Values.service.selectors }}
    {{ tpl (toYaml .Values.service.selectors) . | nindent 4 }}
    {{- else }}
    {{ tpl .Values.service.selectors . | nindent 4}}
    {{- end }}
  type: {{ tpl .Values.service.type . | default "ClusterIP" }}
{{- end -}}
{{- define "common-library.service" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.service.tpl")) -}}
{{- end -}}