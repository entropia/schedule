#!/bin/bash

xmllint_cmd=`command -v xmllint`
curl_cmd=`command -v curl`
xsd_file=`dirname $0`/schedule.xml.xsd

if [ -z "${xmllint_cmd}" ]; then
  echo "Please install xmllint!"
  exit 1
fi

if [ -z "${curl_cmd}" ]; then
  echo "Please install curl!"
fi

if [ -z "${1}" ]; then
  echo "Please provide schedule xml http(s) URL."
  echo "  ${0} http://example.com/schedule.xml"
  exit 1
fi

if [ ! -e "${xsd_file}" ]; then
  echo "schedule.xml.xsd missing!"
  exit 1
fi

if [[ $1 == "http://"* || $1 == "https://"* ]]; then
  $curl_cmd $1 2>/dev/null | $xmllint_cmd --noout --schema ${xsd_file} -
else
  $xmllint_cmd --noout --schema ${xsd_file} $1
fi

xmllint_err=$?
if [ 0 -eq $xmllint_err ]; then
  echo
  echo "Yeeeeeah… ${1} validates ${xsd_file}!!1!"
fi

exit $?
