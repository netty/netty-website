#!/bin/bash -e

pushd "`dirname "$0"`/.." >/dev/null 2>&1
BASE_DIR="$(pwd)"
popd >/dev/null 2>&1

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
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', '$TRACKER_ID', 'auto');
ga('require', 'displayfeatures');
ga('require', 'linkid', 'linkid.js');
ga('send', 'pageview');
</script>"

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

