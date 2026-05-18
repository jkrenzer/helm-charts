{{- define "common-library.persistentVolume.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.persistentVolume -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
apiVersion: v1
kind: PersistentVolume
metadata: {{ $metadata | nindent 2 }}
spec:
  capacity:
    storage: {{ .Values.storage.space }}
  volumeMode: {{ .Values.persistentVolume.volumeMode }}
  accessModes: {{ .Values.storage.accessModes | toYaml | nindent 4 }}
  persistentVolumeReclaimPolicy: {{ .Values.persistentVolume.reclaimPolicy }}
  storageClassName: {{ .Values.storage.storageClassName }}
  {{- if .Values.storage.type | eq "local" }}
  local: 
    path: {{ tpl (required "Local storage path has to be configured!"  .Values.storage.local.path) . }}
  {{- else }}
    {{ fail "Unsupported storage type!" }}
  {{- end }}
  {{- if .Values.storage.hosts}}
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          {{- range $host := .Values.storage.hosts }}
          - {{ $host }}
          {{- end }}
  {{- end }}
{{- end -}}
{{- define "common-library.persistentVolume" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.persistentVolume.tpl")) -}}
{{- end -}}