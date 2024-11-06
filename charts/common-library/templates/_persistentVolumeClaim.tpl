{{- define "common-library.persistentVolumeClaim.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.persistentVolumeClaim -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {{ $metadata | nindent 2 }}
spec:
  storageClassName: {{ tpl .Values.storage.storageClassName . }}
  volumeName: {{ tpl .Values.persistentVolume.name . }}
  accessModes: {{ .Values.storage.accessModes | toYaml | nindent 4 }}
  resources:
    requests:
      storage: {{ .Values.storage.space }}
{{- end -}}
{{- define "common-library.persistentVolumeClaim" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.persistentVolumeClaim.tpl")) -}}
{{- end -}}