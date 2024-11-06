{{- define "common-library.makeMetadata" -}}
name: {{ tpl .locals.name .globals }}
namespace: {{ .globals.Release.Namespace }}
labels: {{ mustMerge .locals.labels .commons.labels | toYaml | nindent 2 }}
annotations: {{ mustMerge .locals.annotations .commons.annotations | toYaml | nindent 2 }}
{{- end -}}