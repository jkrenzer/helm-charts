{{- define "common-library.certificateIssuer.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.certIssuer -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: cert-manager.io/v1
kind: Issuer
metadata: {{ $metadata | nindent 2 }}
spec:
  selfSigned: {}
{{- end -}}
{{- define "common-library.certificateIssuer" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.certificateIssuer.tpl")) -}}
{{- end -}}