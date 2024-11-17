{{- /* 
common-library.util.loadYaml is a convenience macro which loads a
YAML template into the given dict's result key, rendering it with the given globals.
*/ -}}

{{- define "common-library.util.loadYaml" -}}
  {{- $globals := .globals -}}
  {{- set . "result" (fromYaml (include .override $globals) | default (dict )) -}}
{{- end -}}

{{- /*
common-library.util.merge will merge two YAML templates and output the result.

This takes a dict of three values:
- globals: the global context
- override: the template name of the override (destination)
- template: the template name of the base (source)

The rendered template is accessable under .Super in the override template.

Returns the merged dicts as YAML string.
*/ -}}

{{- define "common-library.util.merge" -}}
  {{- $globals := .globals -}}
  {{- $tpl := fromYaml (include .template $globals) | default (dict ) -}}
  {{- $globals := set $globals "Super" $tpl -}}
  {{- $override := fromYaml (include .override $globals) | default (dict ) -}}
  {{- toYaml (mustMerge $override $tpl) -}}
{{- end -}}

{{- /* 
  common-library.util.when filteres a list of objects by the truth value of the template in .when

  This takes a list of parameters:

  - list: The list of objects to filter
  - globals: The global context

  Returns the filtered list as YAML string.
  */ -}}
{{- define "common-library.util.when" -}}
  {{- $list := first . -}}
  {{- if kindIs "slice" $list | not -}}
    {{- fail (printf "common-library.util.when expects a list as first argument, got %s" (kindOf $list)) -}}
  {{- end -}}
  {{- $globals := last . -}}
  {{- $filteredList := list -}}
  {{- range $key, $item := $list -}}
    {{- if kindIs "map" $item -}}
      {{- if hasKey $item "when" -}}
        {{- $when := $item.when -}}
        {{- if $when | kindIs "string" | not -}}
          {{- fail (printf "common-library.util.when expects .when to be a template-string, got %s: %s" ($when | kindOf ) $when) -}}
        {{- end -}}
        {{- $enabled := tpl $when $globals | eq "true" -}}
        {{- if $enabled -}}
          {{- $filteredList = append $filteredList (omit $item "when") -}}
        {{- end -}}
      {{- else -}}
        {{- $filteredList = append $filteredList $item -}}
      {{- end -}}
    {{- else }}
    {{- fail (printf "common-library.util.when cannot operate on %s: %s" (kindOf $item) (toString $item)) -}}
    {{- end -}}
  {{- end -}}
  {{- $filteredList | toYaml -}}
{{- end -}}