#!/bin/bash -e
cd "`dirname "$0"`"
mkdir -p 'wiki'

echo 'Retrieving the wiki page lists ..'
curl -s https://github.com/netty/netty/wiki/_pages | grep -E '<a href="/netty/netty/wiki(/[A-Z][-\._A-Za-z0-9]+)?">[^<]+</a>' > 'wiki/_pages'

echo The wiki contains `wc -l 'wiki/_pages'` pages.

{
  echo '---'
  echo 'layout: base'
  echo "title: 'Docs: All documents'"
  echo '---'
  echo
  echo '%h1 All documentation pages'
  echo
  echo '%ul'
} > 'wiki/all-documents.html.haml'

cat 'wiki/_pages' | while read -r LINE; do
  if [[ ${LINE} =~ (/netty/netty/wiki(/([A-Z][-\._A-Za-z0-9]+))?)\"\>([^\<]+) ]]; then
    WIKI_URI=${BASH_REMATCH[1]}
    WIKI_FILE=${BASH_REMATCH[3]}
    WIKI_GITHUB_NAME="$WIKI_FILE"
    if [[ "x$WIKI_FILE" = 'x' ]]; then
      WIKI_FILE='index'
      WIKI_GITHUB_NAME='Home'
    else
      WIKI_FILE=`echo "$WIKI_FILE" | tr '[:upper:]' '[:lower:]'`
    fi
    WIKI_TITLE=${BASH_REMATCH[4]}
    echo Retrieving: "$WIKI_FILE" from "$WIKI_URI" ..
    {
      echo '---'
      echo 'layout: wiki'
      echo "title: 'Docs: $WIKI_TITLE'"
      echo "simple_title: '$WIKI_TITLE'"
      echo "github_name: '$WIKI_GITHUB_NAME'"
      echo "retrieval_date: '`date '+%d-%b-%Y'`'"
      echo '---'
      echo
      echo ':plain'
      {
        echo "require 'nokogiri'"
        echo '@doc = Nokogiri::HTML::DocumentFragment.parse <<-EOF_92ca82985abd11f6a579fe9b19b578020e0d454d'
        curl -s "https://github.com$WIKI_URI"
        echo 'EOF_92ca82985abd11f6a579fe9b19b578020e0d454d'
        echo 'print @doc.at_css "div#wiki-content"'

        # Perl regex soup below:
        # 1. DOS to UNIX
        # 2. Indentation
        # 3. Remove broken links
        # 4. Make internal links to wiki home work
        # 5. Make internal links to other wiki pages work
        # 6. Escape backslash
        # 7. Escape single-quote
      } | ruby \
        | perl -pi0 -e 's/[\r]//g' \
        | perl -pi -e 's/^/  /g' \
        | perl -pi -e 's/<a [^>]*absent[^>]*>(((?!<\/a>).)*)<\/a>/<span class="broken-link">$1<\/span>/gi' \
        | perl -pi -e 's#/netty/netty/wiki/(Home)?"#index.html"#gi' \
        | perl -pi -e 's#/netty/netty/wiki/([^"]+)#\L$1.html#g' \
        | perl -pi -e 's/\\/\\\\/g' \
        | perl -pi -e "s/'/\\\\'/g"
      echo
    } > "wiki/$WIKI_FILE.html.haml"

    {
      echo '  %li'
      echo "    %a{ :href=>'$WIKI_FILE.html' } $WIKI_TITLE"
    } >> 'wiki/all-documents.html.haml'
  fi
done

{
  echo
  echo '.text-right'
  echo "  %small Last retrived on `date '+%d-%b-%Y'`"
  echo
} >> 'wiki/all-documents.html.haml'

