#!/bin/bash

BIN=`dirname "$0"`
SRC="$BIN/../_site"

if [[ $# -ne 1 ]]; then
  DST="$BIN/../../netty.github.com"
  if [[ ! -d "$DST/.git" ]]; then
    echo 'Specify the path to git@github.com:netty/netty.github.com.git'
    exit 1
  fi
else
  DST="$1"
fi

if [[ ! -d "$DST/.git" ]]; then
  echo "Not a Git repository: $DST"
  exit 1
fi

set -e

function ensure_clean_copy {
  GIT_STATUS="$(git status 2> /dev/null)"
  if [[ ! ${GIT_STATUS} =~ (working directory clean) ]]; then
    echo "Working directory not clean: $PWD"
    exit 1
  fi
  if [[ ${GIT_STATUS} =~ (Your branch is) ]]; then
    echo "Working directory has unpushed changes: $PWD"
    exit 1
  fi
}

# Make sure netty-website is clean
pushd "$BIN/.."
#ensure_clean_copy
popd

# Make sure netty.github.com is clean
pushd "$DST"
if ! git remote -v | grep -q -E '(git@|https://)github.com[:/]netty/netty.github.com'; then
  echo "Not a netty.github.com repository: $PWD"
  exit 1
fi
ensure_clean_copy
popd

# Generate the web site
rm -fr "$SRC"
pushd "$BIN/.."
"$BIN/update-wiki.sh" || exit 1 # Retreve all wiki pages
bundle exec awestruct --generate --force || exit 1
cp -R 3.* 4.* "$SRC" || exit 1
popd

# Pull the latest changes in netty.github.com
pushd "$DST"
git pull --ff-only
popd

# Inject Google Analytics JavaScript in all generated HTMLs
"$BIN/inject-google-analytics.sh" || exit 1

# Copy the generated web site to netty.github.com
rsync -a "$SRC/" "$DST" || exit 1

# Publish the generated web site
cd "$DST"
git add .
git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $(date)"
git push

