{{- define "common-library.ports" -}}
  {{- $ports := include "common-library.util.when" (list .globals.Values.service.ports .globals) | fromYamlArray -}} 
  {{- if not (kindIs "slice" $ports) -}}
    {{- fail (printf "common-library.ports expects a list, got %s" (kindOf $ports)) -}}
  {{- end -}}
  {{- $omit := .omit -}}
  {{- $requiredKeys := list "name" | concat ( .require | default (list) ) -}}
  {{- $portList := list -}}
    {{- $append := true -}}
    {{- range $port := $ports -}}
      {{- range $index, $key := $omit -}}
        {{- $port = omit $port $key -}}
      {{- end -}}
      {{- range $requiredKey := $requiredKeys -}}
        {{- if not (hasKey $port $requiredKey) -}}
          {{- $append = false -}}
          {{- break -}}
        {{- end -}}
      {{- end -}}
      {{- if $append -}}
        {{- $portList = append $portList $port -}}
      {{- end -}}
    {{- end -}}
  {{- tpl ($portList | toYaml) .globals -}}
{{- end -}}
{{- define "common-library.service.ports" -}}
  {{- include "common-library.ports" (dict "omit" (list "containerPort" "hostPort") "globals" $ "require" (list "port") ) -}}
{{- end -}}
{{- define "common-library.container.ports" -}}
  {{- include "common-library.ports" (dict "omit" (list "targetPort" "port") "globals" $ "require" (list "containerPort") ) -}}
{{- end -}}