#!/usr/bin/bash

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

BASE_URL="https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master"
SUPPORTED_FIREJAIL_VERSIONS=("git" "0.9.62" "0.9.60" "0.9.58")
FIREJAIL_PROFILE_NAME="firejailed-tor-browser.profile"
FIREJAIL_PROFILE_LOCATION="$HOME/.config/firejail"
FIREJAIL_PROFILE_PATH="$FIREJAIL_PROFILE_LOCATION/$FIREJAIL_PROFILE_NAME"
DESKTOP_FILE_NAME="firejailed-tor-browser.desktop"
DESKTOP_FILE_LOCATION="$HOME/.local/share/applications"
DESKTOP_FILE_PATH="$DESKTOP_FILE_LOCATION/$DESKTOP_FILE_NAME"

usage()
{
  cat << EOM
Updater script for FTB to update (or install) the firejail-profile and
the .desktop file.

Usage:
    ./update.sh [OPTIONS]

 OPTIONS:
  --help -h -?          -- show this help and exit.
  --firejail=<VERSION>  -- specify firejail version (default: git)
                           supported versions: ${SUPPORTED_FIREJAIL_VERSIONS[@]}

License: MIT
EOM
  exit
}

backup_file()
{
  # Check if $1 exists, if so add `.bak-NOW' to the filename.
  if [ -e "$1" ]; then
    mv "$1" "$1.bak-$(date --iso-8601=seconds)"
    #echo "[ Ok ] Backup of $1 created."
  fi
}

parse_arguments()
{
  HELP=false
  FIREJAIL_VERSION="git"

  for arg in "$@"; do
    case $arg in
      --help|-h|-\?)
        HELP=true
      ;;
      --firejail=*)
        FIREJAIL_VERSION="${arg#*=}"
      ;;
      --*|-?)
        echo "[ Warning ] Unknow commandline argument: $arg."
      ;;
    esac
  done
}

check_firejail_version()
{
  if [ "$FIREJAIL_VERSION" == "git" ]; then
    return 0
  fi

  unsupported=true
  for version in "${SUPPORTED_FIREJAIL_VERSIONS[@]}"; do
    if [ "$FIREJAIL_VERSION" == "$version" ]; then
      unsupported=false
      BASE_URL="$BASE_URL/stable-profiles/$FIREJAIL_VERSION"
      break
    fi
  done

  if $unsupported; then
    echo "[ Error ] Unsupported firejail version: $FIREJAIL_VERSION."
    exit 1
  fi
}

prepare_filesystem()
{
  mkdir -v -p "$FIREJAIL_PROFILE_LOCATION"
  backup_file "$FIREJAIL_PROFILE_PATH"

  mkdir -v -p "$DESKTOP_FILE_LOCATION"
  backup_file "$DESKTOP_FILE_PATH"

  echo "[ Ok ] Prepared filesystem."
}

download()
{
  FIREJAIL_PROFILE_URL="$BASE_URL/$FIREJAIL_PROFILE_NAME"
  DESKTOP_FILE_URL="$BASE_URL/$DESKTOP_FILE_NAME"

  if [ -n "$(command -v wget)" ]; then
    dl_cmd="wget"
    dl_cmd_args=("-O-" "-q")
  elif [ -n "$(command -v curl)" ]; then
    dl_cmd="curl"
    dl_cmd_args=()
  else
    echo "[ Error ] Neither wget nor curl could be found."
    exit 1
  fi

  $dl_cmd "${dl_cmd_args[@]}" "$FIREJAIL_PROFILE_URL" > "$FIREJAIL_PROFILE_PATH"
  echo "[ Ok ] Downloaded $FIREJAIL_PROFILE_NAME."

  $dl_cmd "${dl_cmd_args[@]}" "$DESKTOP_FILE_URL" | sed "s,HOME,$HOME,g" > "$DESKTOP_FILE_PATH"
  echo "[ Ok ] Downloaded $DESKTOP_FILE_NAME."
}

fix_disable-programs()
{
  if [ "$FIREJAIL_VERSION" == "0.9.58" ]; then
    echo "[ Warning ] Fixing disbale-programs is only supported for firejail 0.9.60 and newer."
    echo "[ Info ] To fix disable-programs manualy execute the following as root if you know what it does:"
    echo "[ Info ]     sh -c 'echo \${HOME}/.firejailed-tor-browser' >> /etc/firejail/disable-programs.local"
    return
  fi

  # Make sure ${HOME}/.config/firejail/disable-programs.local exists.
  touch "${HOME}/.config/firejail/disable-programs.local"

  # Add 'blacklist ${HOME}/.firejailed-tor-browser' to disable-programs.inc unless it's present.
  if ! grep --quiet "blacklist \${HOME}/.firejailed-tor-browser" "${HOME}/.config/firejail/disable-programs.local"; then
    echo "blacklist \${HOME}/.firejailed-tor-browser" >> "${HOME}/.config/firejail/disable-programs.local"
    echo "[ Ok ] Fixed disbale-programs.inc."
  fi
}

main()
{
  parse_arguments "$@"
  $HELP && usage
  check_firejail_version
  prepare_filesystem
  download
  fix_disable-programs
  echo "[ Ok ] Done!"
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@";:
