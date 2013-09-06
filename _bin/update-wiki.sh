#!/bin/bash -e
cd "`dirname "$0"`/.."
rm -fr 'wiki'
mkdir 'wiki'

echo 'Retrieving the wiki page list ..'
curl -s https://github.com/netty/netty/wiki/_pages | grep -E '<a href="/netty/netty/wiki(/[A-Z][-\._A-Za-z0-9]+)?">[^<]+</a>' > 'wiki/_pages'

PAGE_CNT=`cat wiki/_pages | wc -l | sed -e 's/ //g'`

if [[ -z "$PAGE_CNT" ]] || [[ "$PAGE_CNT" -le 0 ]]; then
  echo "Failed to retrieve the wiki page list"
  exit 1
fi

echo The wiki contains "$PAGE_CNT" pages.

{
  echo '---'
  echo 'layout: jumbotronless'
  echo "title: 'All documents'"
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
    WIKI_TMPFILE="`mktemp -t XXX`"

    {
      echo '# encoding: UTF-8'
      echo "require 'nokogiri'"
      echo "require 'htmlentities'"
      echo "@doc = Nokogiri::HTML::DocumentFragment.parse <<-'EOF_92ca82985abd11f6a579fe9b19b578020e0d454d'"
      curl -s "https://github.com$WIKI_URI" || exit 1
      echo
      echo 'EOF_92ca82985abd11f6a579fe9b19b578020e0d454d'

      # Generate TOC
      echo '
        toc_html = ""
        headings = @doc.css("#wiki-content h2, #wiki-content h3, #wiki-content h4")
        if headings.size() > 1 and @doc.css("#wiki-notoc").size() == 0
          coder = HTMLEntities.new
          toc_idx = 0
          toc_level = 2
          first = true
          toc_html << "<div class=\"toc well\">\n"
          toc_html << "<ul class=\"nav nav-list nav-stacked\">\n"
          toc_html << "<li class=\"nav-header\">Table of Contents\n"
          for h in headings
            section_id = "wiki-" + h.name + "-" + toc_idx.to_s
            toc_idx = toc_idx + 1
            h["id"] = section_id
            new_toc_level = h.name[1].ord - 48
            toc_text = coder.encode(h.inner_text).strip
            if new_toc_level == toc_level
              toc_html << "</li><li><a href=\"#" + section_id + "\" title=\"" + toc_text + "\">" + toc_text + "</a>\n"
              first = false
            elsif new_toc_level == toc_level + 1
              if first # first heading is not h2 but h3
                toc_html << "</li><li>\n"
              end
              toc_level = new_toc_level
              toc_html << "<ul class=\"nav nav-list nav-stacked\"><li><a href=\"#" + section_id + "\" title=\"" + toc_text + "\">" + toc_text + "</a>\n"
              first = false;
            elsif !first and new_toc_level < toc_level
              toc_html << "</li></ul>" * (toc_level - new_toc_level)
              toc_html << "</li><li><a href=\"#" + section_id + "\" title=\"" + toc_text + "\">" + toc_text + "</a>\n"
              toc_level = new_toc_level
              first = false;
            end
          end
          while toc_level >= 2
            toc_level = toc_level - 1
            toc_html << "</li></ul>\n"
          end
          toc_html << "</div>\n"
        end
      '

      # Enable tab switching
      echo '
        for e in @doc.css("ul.nav-tabs li a")
          e["data-toggle"] = "tab"
        end
      '

      # Print the wiki body and the generated toc together.
      echo '
        if toc_html == ""
          print @doc.at_css "div#wiki-body"
        else
          puts "<div class=\"row\">"
          puts "<div class=\"col-md-9\">"
          print @doc.at_css "div#wiki-body"
          puts "</div>"
          puts "<div class=\"col-md-3 hidden-xs hidden-sm hidden-print\" role=\"complementary\">"
          print toc_html
          puts "</div>"
          puts "</div>"
        end
      '
    } | ruby >> "$WIKI_TMPFILE"
      
    # Perl regex soup below:
    # 1. DOS to UNIX
    # 2. Indentation
    # 3. Remove broken links
    # 4. Make internal links to wiki home work
    # 5. Make internal links to other wiki pages work
    # 6. Add Bootstrap class to table tags
    perl -pi0 -e 's/[\r]//g' "$WIKI_TMPFILE"
    perl -pi -e 's/^/  /g' "$WIKI_TMPFILE"
    perl -pi -e 's/<a [^>]*absent[^>]*>(((?!<\/a>).)*)<\/a>/<span class="broken-link">$1<\/span>/gi' "$WIKI_TMPFILE"
    perl -pi -e 's#/netty/netty/wiki/(Home)?"#index.html"#gi' "$WIKI_TMPFILE"
    perl -pi -e 's#/netty/netty/wiki/((?!images/)[^"]+)#\L$1.html#g' "$WIKI_TMPFILE"
    perl -pi -e 's/<table>/<table class="table table-hover">/gi' "$WIKI_TMPFILE"

    {
      echo '---'
      echo 'layout: wiki'
      echo "title: '$WIKI_TITLE'"
      echo "github_name: '$WIKI_GITHUB_NAME'"
      echo "retrieval_date: '`date '+%d-%b-%Y'`'"
      echo '---'
      echo
      echo ':plain'
      cat "$WIKI_TMPFILE"
    } > "wiki/$WIKI_FILE.html.haml"

    rm -f "$WIKI_TMPFILE"

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

# Ensure all wiki pages were retrieved and indexed.

INDEXED_PAGE_CNT=`grep -F '%li' 'wiki/all-documents.html.haml' | wc -l | sed -e 's/ //g'`
if [[ "$INDEXED_PAGE_CNT" != "$PAGE_CNT" ]]; then
  echo "Mismatching number of wiki pages in all-documents: $INDEXED_PAGE_CNT (expected: $PAGE_CNT)"
  exit 1
fi

((PAGE_CNT++)) # Consider all-documents.html.haml

ACTUAL_PAGE_CNT=`find wiki -name '*.html.haml' | wc -l | sed -e 's/ //g'`

if [[ "$ACTUAL_PAGE_CNT" != "$PAGE_CNT" ]]; then
  echo "Mismatching number of generated files: $ACTUAL_PAGE_CNT (expected: $PAGE_CNT)"
  exit 1
fi

exec _bin/generate.sh

