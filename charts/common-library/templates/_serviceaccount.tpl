{{- define "common-library.serviceAccount.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.serviceAccount -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: ServiceAccount
metadata: 
  {{- $metadata | nindent 2 }}
automountServiceAccountToken: {{ .Values.serviceAccount.automount }}
{{- end }}
{{- define "common-library.serviceAccount" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.serviceAccount.tpl")) -}}
{{- end -}}