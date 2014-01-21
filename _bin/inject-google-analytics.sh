#!/bin/bash -e

BASE_DIR="`dirname "$0"`/.."
#BASE_DIR="`readlink -m "$BASE_DIR"`"

if [[ $# -eq 0 ]]; then
  cd "$BASE_DIR/_site"
elif [[ $# -eq 1 ]]; then
  cd "$1"
else
  while [[ $# -gt 1 ]]; do
    "$0" "$1"
    shift
  done
  cd "$1"
fi

TRACKER_ID="UA-95307-5"
TRACKER_CODE="<script type=\"text/javascript\">
var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");
document.write(unescape(\"%3Cscript src='\" + gaJsHost + \"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E\"));
</script>
<script type=\"text/javascript\">
try {
var pageTracker = _gat._getTracker('$TRACKER_ID');
pageTracker._trackPageview();
} catch(err) {}</script>"

# Find the files injected already.
grep -Flr "$(printf "<frameset\n<FRAMESET\n$TRACKER_ID")" . | sort > "$BASE_DIR/.analytics-injected"

# Find the files not injected yet.
find . '(' -name '*.html' -and -not -name '*-frame.html' ')' | sort | comm -23 - "$BASE_DIR/.analytics-injected" > "$BASE_DIR/.analytics-uninjected"

# Inject the files.
NUM_FILES=`wc -l < "$BASE_DIR/.analytics-uninjected"`
if [[ $NUM_FILES -gt 0 ]]; then
  echo -n "Injecting $NUM_FILES file(s) .. "
  cat "$BASE_DIR/.analytics-uninjected" | tr '\n' '\0' | xargs -0 -n 32 perl -pi -e "s/(<\\/body>)/\\n${TRACKER_CODE////\\/}\\n\$1/i"
  echo done
else
  echo "No files to inject."
fi

