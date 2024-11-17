{{- define "common-library.container.tpl" -}}
env:
  {{ range $name, $tpl_value := .Values.environmentVars -}}
  {{- $value := false -}}
  {{- if kindIs "string" $tpl_value -}}
  {{- $value = tpl $tpl_value $ | trimAll "\"" -}}
  {{- else -}}
  {{- $value = tpl ($tpl_value | toYaml) $ | fromYaml -}}
  {{- end -}}
  {{ if $value }}
    - name: {{ $name | upper }} 
      {{- if kindIs "map" $value }}
      {{- tpl (toYaml $value) $ | nindent 6 }}
      {{- else }}
      value: {{ if or (kindIs "float64" $value) (kindIs "int64" $value) (kindIs "int" $value) -}}
          {{ $value | toYaml }}
        {{- else -}}
          {{ $value | quote }}
        {{- end -}}
      {{- end -}}
  {{ end -}}
  {{ end }}
name: {{ .Chart.Name }}
{{- with .Values.securityContext }}
securityContext:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
image: {{ .Values.image.repository }}:{{ tpl .Values.image.tag . }}
imagePullPolicy: {{ .Values.image.pullPolicy }}
ports: 
  {{- include "common-library.container.ports" . | nindent 2 }}
{{- with .Values.livenessProbe }}
livenessProbe:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- with .Values.readinessProbe }}
readinessProbe:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- with .Values.startupProbe }}
startupProbe:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- with .Values.resources }}
resources:
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- with .Values.volumeMounts }}
volumeMounts: 
  {{- tpl (include "common-library.util.when" (list . $)) $ | nindent 2 }}
{{- end }}
{{- end -}}
{{- define "common-library.container" -}}
{{- include "common-library.util.merge" (merge . (dict "template" "common-library.container.tpl")) -}}
{{- end -}}