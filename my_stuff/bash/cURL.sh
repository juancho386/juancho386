#!/bin/bash
URL=${1:-google.com}
PORT=${2:-80}

exec 3<>/dev/tcp/${URL}/${PORT}
trap "echo Closing socket;exec 3>&-" EXIT

lines=(
	'GET /robots.txt HTTP/1.1'
	"Host: ${URL}"
	"Conenction: close"
	''
)
printf '%s\r\n' "${lines[@]}" >&3
while read -r data <&3; do
	echo "Told me: $data"
done

