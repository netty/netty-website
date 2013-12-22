#!/bin/bash -e

cd "`dirname "$0"`"
BIN="`pwd`"
SRC="$BIN/../_site"
cd "$BIN/.."

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

function spushd {
  pushd "$@" > /dev/null
}

function spopd {
  popd "$@" > /dev/null
}

function ensure_clean_copy {
  GIT_STATUS="$(git status 2> /dev/null)"
  if [[ ! ${GIT_STATUS} =~ (working directory clean) ]]; then
    echo "Working directory not clean: $PWD"
    exit 1
  fi
  if [[ ! ${GIT_STATUS} =~ (Your branch is up-to-date with ) ]]; then
    if [[ ${GIT_STATUS} =~ (Your branch is) ]]; then
      echo "Working directory has unpushed changes: $PWD"
      exit 1
    fi
  fi
}

# Make sure netty-website is clean
spushd "$BIN/.."
ensure_clean_copy
spopd

# Make sure netty.github.com is clean
spushd "$DST"
if ! git remote -v | grep -q -E '(git@|https://)github.com[:/]netty/netty.github.com'; then
  echo "Not a netty.github.com repository: $PWD"
  exit 1
fi
ensure_clean_copy
spopd

# Generate the web site
rm -fr "$SRC"
spushd "$BIN/.."
"$BIN/update-wiki.sh" # Retreve all wiki pages
bundle exec awestruct --generate --force
cp -R [3456789].* "$SRC"
spopd
touch "$SRC/.nojekyll"

# Pull the latest changes in netty.github.com
spushd "$DST"
git reset --hard HEAD
git fetch origin master
git checkout origin/master 2> /dev/null
git branch -D master 2> /dev/null
git checkout -B master 2> /dev/null
NUM_DEPLOYS=$(git rev-list --count HEAD)
spopd

if [[ -z "$NUM_DEPLOYS" ]]; then
  echo 'Failed to get the repository information.'
  exit 1
fi

# Inject Google Analytics JavaScript in all generated HTMLs
"$BIN/inject-google-analytics.sh"

DATE="$(date -u '+%Y-%m-%d %H:%M:%S')"
if [[ $NUM_DEPLOYS -lt 128 ]]; then
  # Copy the generated web site to netty.github.com
  rsync -a --delete --exclude=.git/ "$SRC/" "$DST"

  # Publish the generated web site
  cd "$DST"
  git add -A
  git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $DATE"
  git push -u --force origin master
else
  # Rewind to the initial commit.
  spushd "$DST"
  git checkout 533f5da7361390c306889bbe6bfe25a47b2f4a9c
  spopd

  # Copy the generated web site to netty.github.com
  rsync -a --delete --exclude=.git/ "$SRC/" "$DST"

  # Publish the generated web site
  cd "$DST"
  git add -A
  git commit -m "Deploy site '$(git log -1 --format=format:%h)' on $DATE"
  git branch -D master
  git checkout -B master
  git push -u --force origin master
  git gc
fi

echo
echo 'Deployment successful. Wait about 5 minutes to give GitHub pages to synchronize.'
echo "If the web site is still out-of-date, try to run '$BIN/purge-cloudflare.sh'"

