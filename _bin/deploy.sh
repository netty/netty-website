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
touch "$SRC/.nojekyll"

# Pull the latest changes in netty.github.com
pushd "$DST"
git reset --hard HEAD || exit 1
git checkout master || exit 1
git pull --ff-only origin master || exit 1
NUM_DEPLOYS=$(git rev-list --count HEAD)
popd

if [[ -z "$NUM_DEPLOYS" ]]; then
  echo 'Failed to get the repository information.'
  exit 1
fi

# Inject Google Analytics JavaScript in all generated HTMLs
"$BIN/inject-google-analytics.sh" || exit 1

DATE="$(date -u '+%Y-%m-%d %H:%M:%S')"
if [[ $NUM_DEPLOYS -lt 16 ]]; then
  # Copy the generated web site to netty.github.com
  rsync -a --delete --exclude=.git/ "$SRC/" "$DST" || exit 1

  # Publish the generated web site
  cd "$DST"
  git add -A
  git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $DATE"
  git push -u --force origin master
else
  # Rewind to the initial commit.
  pushd "$DST"
  git checkout 533f5da7361390c306889bbe6bfe25a47b2f4a9c || exit 1
  git branch -D master || exit 1
  git checkout -B master || exit 1
  popd

  # Copy the generated web site to netty.github.com
  rsync -a --delete --exclude=.git/ "$SRC/" "$DST" || exit 1

  # Publish the generated web site
  cd "$DST"
  git add -A
  git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $DATE"
  git push -u --force origin master
fi

