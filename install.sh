#!/usr/bin/env bash

# Copyright (c) 2019,2020 rusty-snake (https://github.com/rusty-snake) <print_hello_world+License@protonmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e
umask 077

FTB_LOCATION="$HOME/.firejailed-tor-browser"

usage()
{
  cat << EOM
Usage:
    ./install.sh [OPTIONS] <PATH_TO_TOR_BROWSER_ARCHIV>

 OPTIONS:
    --help,-h,-?        Show this help and exit.
    --firejail=VERSION  Add --firejail=VERSION to the update.sh call
EOM
  exit
}

extract()
{
  if [ -e "$FTB_LOCATION" ]; then
    mv "$FTB_LOCATION" "$FTB_LOCATION.bak-$(date --iso-8601=seconds)"
  fi

  mkdir -p "$FTB_LOCATION"

  echo "[ Info ] Extracting the tor-browser ..."
  tar -C "$FTB_LOCATION" --strip 1 -xJf "$1"
  echo "[ Ok ] tor-browser extracted."
}

parse_arguments()
{
  HELP=false

  for arg in "$@"; do
    case $arg in
      --help|-h|-\?)
        HELP=true
      ;;
      --firejail=*)
        FIREJAIL_VERSION="$arg"
      ;;
      --*|-?)
        echo "[ Warning ] Unknow commandline argument: $arg"
      ;;
      *)
        TBB_PATH="$arg"
	break
      ;;
    esac
  done
}

main()
{
  parse_arguments "$@"
  $HELP && usage
  if [ ! -v TBB_PATH ]; then
    echo "[ Error ] <PATH_TO_TOR_BROWSER_ARCHIV> not given"
    exit 1
  fi
  extract "$TBB_PATH"
  #"$(dirname "$0")"/update.sh
  (
    # shellcheck source=update.sh
    . "$(dirname "$0")"/update.sh
    parse_arguments "$FIREJAIL_VERSION"
    check_firejail_version
    prepare_filesystem
    download
    fix_disable-programs
  )

  echo "[ Ok ] Done! The installation was successful, you can now launch the tor-browser by running:"
  echo "[ Ok ]   firejail --profile=firejailed-tor-browser \"\$HOME/Browser/start-tor-browser\""
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@";:
