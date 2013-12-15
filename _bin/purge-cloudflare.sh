#!/bin/bash -e

cd "`dirname "$0"`/.."

TOKEN_FILE='.cloudflare_token'
if [[ -f "$TOKEN_FILE" ]]; then
  TOKEN="`cat "$TOKEN_FILE"`"
else
  echo "$TOKEN_FILE does not exist. Please type the CloudFlare API key:"
  read -s TOKEN
fi

if [[ ! "$TOKEN" =~ ([0-9a-f]+) ]]; then
  echo "Malformed token."
  exit 1
fi

RESULT="`curl https://www.cloudflare.com/api_json.html -s -d 'a=fpurge_ts' -d "tkn=$TOKEN" -d 'email=t@motd.kr' -d 'z=netty.io' -d 'v=1'`"

if [[ "$RESULT" =~ (\"result\":\"success\") ]]; then
  echo 'Successfully purged the CloudFlare cache.'
  if [[ ! -f "$TOKEN_FILE" ]]; then
    echo "Saved your token to: $TOKEN_FILE"
    echo -n "$TOKEN" > "$TOKEN_FILE"
  fi
else
  echo 'Failed to purge the CloudFlare cache:'
  echo "$RESULT"
  exit 1
fi

