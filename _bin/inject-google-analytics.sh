#!/bin/bash

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

cd "`dirname $0`/../_site"
if [[ "$?" != '0' ]]; then
  echo "Failed to find the base directory."
  exit 1
fi

find . -name '*.html.new' -delete
find . '(' -name '*.html' -and -not -name '*-frame.html' ')' | while read -r TARGET; do
  if grep -qiE "(<frameset|$TRACKER_ID)" "$TARGET"; then
    continue;
  fi

  if grep -qiF '</body>' "$TARGET"; then
    perl -pi -e "s/(<\\/body>)/\\n${TRACKER_CODE////\\/}\\n\$1/i" < "$TARGET" > "$TARGET.new"
  else
    { cat "$TARGET"; echo; echo "$TRACKER_CODE"; echo; } > "$TARGET.new"
  fi
  if ! grep -qF "$TRACKER_ID" "$TARGET.new"; then
    echo "Failed to inject analytics script: $TARGET"
    cat "$TARGET.new"
    rm -f "$TARGET.new"
    exit 1
  fi
  mv -f "$TARGET.new" "$TARGET"
  echo "$TARGET"
done

