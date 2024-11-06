{{- /*
common-library.util.merge will merge two YAML templates and output the result.
This takes a dict of three values:
- globals: the global context
- override: the template name of the override (destination)
- template: the template name of the base (source)
*/}}
{{- define "common-library.util.merge" -}}
{{- $globals := .globals -}}
{{- $override := fromYaml (include .override $globals) | default (dict ) -}}
{{- $tpl := fromYaml (include .template $globals) | default (dict ) -}}
{{- toYaml (merge $override $tpl) -}}
{{- end -}}