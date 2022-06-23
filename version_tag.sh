#!/bin/sh

# Last edit 2020-06-12

set -o nounset
set -o errexit

# you can add the following lines to .git/hooks/pre-commit to auto bump build num:
#
# ./version_bump.sh
# git add version.go

usage(){
  echo "Usage: $0"
}

set_tag(){

  APP_NAME="$(grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g')"
  APP_VSN="$(grep 'version:' mix.exs | cut -d '"' -f2)"
  NOW="$(date +%Y-%m-%dT%H:%M:%S%z)"

  echo "set_tag: v${APP_VSN}"
  echo "set_tag_date: ${NOW}"

  git add mix.exs

  echo "git commit -m \"tagging version v${APP_VSN}\""
  if ! git commit -m "tagging version v${APP_VSN}" ; then
    echo "git commit failure.  Did you forget to bump major, minor or patch?"
    exit 18
  fi

  echo "git tag \"v${APP_VSN}\""
  git tag "v${APP_VSN}"

  echo ""
  echo "in order to \"undo\" the commit:"
  echo "git reset --soft HEAD^"
  echo ""
  echo "if you need to remove the tag, use:"
  echo "git tag -d v${APP_VSN}"
  echo "git push origin :v${APP_VSN}"
  echo ""
  echo "use the following command to push tag to origin:"
  echo "git push && git push --tags"
}


set_tag