{{- define "common-library.certificate.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.cert -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: cert-manager.io/v1
kind: Certificate
metadata: {{ $metadata | nindent 2 }}
spec:
  commonName: {{ .Values.config.domain }}
  dnsNames: {{ mustPrepend .Values.cert.dnsNames .Values.config.domain | toYaml | nindent 4 }}
  issuerRef:
    name: {{ tpl ( required "You need to set .Values.cert.issuer to use cert-manager!" .Values.cert.issuer ) . }}
  secretName: {{ tpl .Values.certSecret.name . }}
  secretTemplate: {{ tpl ( .Values.certSecret.template ) . | nindent 4 }}
{{- end -}}
{{- define "common-library.certificate" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.certificate.tpl")) -}}
{{- end -}}