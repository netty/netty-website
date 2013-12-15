#!/bin/bash -e

cd "`dirname "$0"`/../_site"

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
grep -Flr "$(printf "<frameset\n<FRAMESET\n$TRACKER_ID")" . | sort > ../.analytics-injected

# Find the files not injected yet.
find . '(' -name '*.html' -and -not -name '*-frame.html' ')' | sort | comm -23 - ../.analytics-injected > ../.analytics-uninjected

# Inject the files.
NUM_FILES=`wc -l < ../.analytics-uninjected`
if [[ $NUM_FILES -gt 0 ]]; then
  echo -n "Injecting $NUM_FILES file(s) .. "
  cat ../.analytics-uninjected | tr '\n' '\0' | xargs -0 -n 32 perl -pi -e "s/(<\\/body>)/\\n${TRACKER_CODE////\\/}\\n\$1/i"
  echo done
else
  echo "No files to inject."
fi

