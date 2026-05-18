{{- define "common-library.makeMetadata" -}}
name: {{ tpl .locals.name .globals }}
namespace: {{ .globals.Release.Namespace }}
labels: 
  {{- merge .locals.labels .commons.labels | toYaml | nindent 2 }}
annotations: 
  {{- merge .locals.annotations .commons.annotations | toYaml | nindent 2 }}
{{- end -}}