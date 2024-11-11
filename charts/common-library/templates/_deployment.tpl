{{- define "common-library.deployment.tpl" -}}
{{- $commons  := .Values.common  -}}
{{- $locals   := .Values.deployment -}}
{{- $metadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
{{- $locals   := .Values.pod -}}
{{- $podMetadata := include "common-library.makeMetadata" (dict "locals" $locals "commons" $commons "globals" .) -}}
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
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ tpl .Values.serviceAccount.name . }}
      securityContext: 
        {{- toYaml .Values.pod.securityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: {{ .Values.image.repository }}:{{ tpl .Values.image.tag . }}
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports: 
            {{- range .Values.service.ports }}
            {{- if( tpl (default .when "true") . | fromYaml ) }}
            - {{ toYaml ( omit . "when") | nindent 14 | trim }}
            {{- end }}
            {{- end }}
          livenessProbe:
            {{- toYaml .Values.livenessProbe | nindent 12 }}
          readinessProbe:
            {{- toYaml .Values.readinessProbe | nindent 12 }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          {{- with .Values.volumeMounts }}
          volumeMounts: 
            {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- with .Values.volumes }}
      volumes: 
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector: 
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity: 
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations: 
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end -}}
{{- define "common-library.deployment" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.deployment.tpl")) -}}
{{- end -}}