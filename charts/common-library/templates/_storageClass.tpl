{{- define "common-library.storageClass.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.storageClass -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata: {{ $metadata | nindent 2 }}
provisioner: {{ .Values.storageClass.provisioner }}
volumeBindingMode: {{ .Values.storageClass.volumeBindingMode }}
{{- end -}}
{{- define "common-library.storageClass" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.storageClass.tpl")) -}}
{{- end -}}