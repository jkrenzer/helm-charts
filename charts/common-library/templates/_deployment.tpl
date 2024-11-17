{{- define "common-library.deployment.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.deployment -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
{{- $locals   := .Values.pod -}}
{{- $podMetadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
{{- $containerIncludeName := (printf "%s.container" .Values.common.name) -}}
apiVersion: apps/v1
kind: Deployment
metadata: 
  {{- $metadata | nindent 2 }}
spec:
  {{- if eq .Values.deployment.autoscaling.enable false }}
  replicas: {{ .Values.deployment.replicas }}
  {{- end }}
  selector:
    matchLabels: {{ mustMerge .Values.pod.labels .Values.common.labels | toYaml | nindent 6 }}
  template:
    metadata: 
      {{- $podMetadata | nindent 6 }}
    spec:
      {{- with .Values.image.pullSecrets }}
      imagePullSecrets: 
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ tpl .Values.serviceAccount.name . }}
      {{- with .Values.pod.securityContext }}
      securityContext: 
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
      hostname: {{ tpl ( .Values.pod.hostname | default  .Values.common.name  ) . }}
      containers:
        - {{ include "common-library.container" (dict "globals" . "override" $containerIncludeName) | nindent 10 }}
      {{- with .Values.volumes }}
      volumes: 
        {{- tpl (include "common-library.util.when" (list . $)) $ | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector: 
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity: 
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations: 
        {{- tpl (toYaml .) $ | nindent 8 }}
      {{- end }}
{{- end -}}
{{- define "common-library.deployment" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.deployment.tpl")) -}}
{{- end -}}