{{/* Define the secrets */}}
{{- define "tracearr.secrets" -}}
{{- $secretName := (printf "%s-tracearr-secrets" (include "tc.v1.common.lib.chart.names.fullname" $)) }}

{{- $jwtSecret := randAlphaNum 64 -}}
{{- $cookieSecret := randAlphaNum 64 -}}
{{- $maxmindLicenseKey := (default "" .Values.tracearr.maxmind.licenseKey) -}}

{{- with lookup "v1" "Secret" .Release.Namespace $secretName -}}
  {{- if and .data (hasKey .data "JWT_SECRET") -}}
    {{- $jwtSecret = index .data "JWT_SECRET" | b64dec -}}
  {{- end -}}
  {{- if and .data (hasKey .data "COOKIE_SECRET") -}}
    {{- $cookieSecret = index .data "COOKIE_SECRET" | b64dec -}}
  {{- end -}}
  {{- if and (not $maxmindLicenseKey) .data (hasKey .data "MAXMIND_LICENSE_KEY") -}}
    {{- $maxmindLicenseKey = index .data "MAXMIND_LICENSE_KEY" | b64dec -}}
  {{- end -}}
{{- end }}

enabled: true
data:
  JWT_SECRET: {{ $jwtSecret | quote }}
  COOKIE_SECRET: {{ $cookieSecret | quote }}
  MAXMIND_LICENSE_KEY: {{ $maxmindLicenseKey | quote }}
{{- end -}}
