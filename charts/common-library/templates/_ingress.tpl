{{- define "common-library.ingress.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.ingress -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata: {{ $metadata | nindent 2 }}
spec:
  rules:
    - host: {{ .Values.config.domain }}
      http:
        paths: {}
  {{ if .Values.config.tls.enable -}}
  tls:
    - hosts:
        - {{ .Values.config.domain }}
      secretName: {{ tpl .Values.certSecret.name . }}
  {{- end }}
{{- end -}}
{{- define "common-library.ingress" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.ingress.tpl")) -}}
{{- end -}}