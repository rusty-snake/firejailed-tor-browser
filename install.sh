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

BASE_URL="https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master"
FJ_PROFILE="firejailed-tor-browser.profile"
DESKTOP_FILE="firejailed-tor-browser.desktop"

backup_file()
{
  if [ -e "$1" ]; then
    mv "$1" "$1.bak-$(date --iso-8601=seconds)"
    echo "[ Ok ] backup of $1 created"
  fi
}

download_with_wget()
{
  wget -O - "${BASE_URL}/${FJ_PROFILE}" 2>/dev/null > "${HOME}/.config/firejail/${FJ_PROFILE}"
  echo "[ Ok ] firejail profile for firejailed-tor-browser downloaded"
  wget -O - "${BASE_URL}/${DESKTOP_FILE}" 2>/dev/null | sed "s,HOME,${HOME},g" > "${HOME}/.local/share/applications/${DESKTOP_FILE}"
  echo "[ Ok ] firejailed-tor-browser.desktop downloaded"
}

download_with_curl()
{
  curl "${BASE_URL}/${FJ_PROFILE}" 2>/dev/null > "${HOME}/.config/firejail/${FJ_PROFILE}"
  echo "[ Ok ] firejail profile for firejailed-tor-browser downloaded"
  curl "${BASE_URL}/${DESKTOP_FILE}" 2>/dev/null | sed "s,HOME,${HOME},g" > "${HOME}/.local/share/applications/${DESKTOP_FILE}"
  echo "[ Ok ] firejailed-tor-browser.desktop downloaded"
}

download()
{
  if [ -n "$(command -v wget)" ]; then
    download_with_wget
    return 0
  elif [ -n "$(command -v curl)" ]; then
    download_with_curlreturn 0
    return 0
  else
    return 1
  fi
}

fix_disable-programs()
{
  if [ -v FIREJAIL_VERSION ] && [ "$FIREJAIL_VERSION" == "0.9.58" ]; then
    echo "[ Warning ] fixing disbale-programs is only supported for firejail 0.9.60 and newer."
    echo "[ Info ] to fix disable-programs, execute the following as root if you know what it does:"
    echo "[ Info ]     sh -c 'echo \${HOME}/.firejailed-tor-browser' >> /etc/firejail/disable-programs.local"
    return
  fi
  if ! grep --quiet "blacklist \${HOME}/.firejailed-tor-browser" "${HOME}/.config/firejail/disbale-programs.local"; then
    # shellcheck disable=SC2016
    echo 'blacklist ${HOME}/.firejailed-tor-browser' >> "${HOME}/.config/firejail/disbale-programs.local"
    echo "[ Ok ] disbale-programs fixed"
  fi
}

extract()
{
  if $ONLY_UPDATE; then
    echo "[ Info ] Skiping extracting of the tor-browser"
    return
  fi

  echo "[ Info ] extracting the tor-browser ..."
  tar -C "${HOME}/.firejailed-tor-browser" --strip 1 -xJf "$1"
  echo "[ Ok ] tor-browser extracted"
}

prepare_filesystem()
{
  if ! $ONLY_UPDATE; then
    backup_file "${HOME}/.firejailed-tor-browser"
    mkdir "${HOME}/.firejailed-tor-browser"
  fi

  mkdir -v -p "${HOME}/.config/firejail"
  backup_file "${HOME}/.config/firejail/${FJ_PROFILE}"

  mkdir -v -p "${HOME}/.local/share/applications"
  backup_file "${HOME}/.local/share/applications/${DESKTOP_FILE}"

  echo "[ Ok ] filesystem prepared"
}

usage()
{
  cat << EOM
Usage:
    ./$(basename "$0") [OPTIONS] [--] <PATH_TO_TOR_BROWSER_ARCHIV>

 OPTIONS:
    --help,-h,-?        Show this help and exit.
    --update            Update only the firejail profile and the .desktop file.
    --firejail=VERSION  Install files for a older firejail version.
                        Supported version: 0.9.62, 0.9.60, 0.9.58
    --clean             Not implemented yet.
    --clean-all         Not implemented yet.
EOM
}

parse_arguments()
{
  SHOW_HELP="false"
  ONLY_UPDATE="false"
  CLEAN="false"
  CLEAN_ALL="false"

  for arg in "$@"; do
    case $arg in
      --help|-h|-\?)
        SHOW_HELP="true"
      ;;
      --update)
        ONLY_UPDATE="true"
      ;;
      --firejail=*)
        FIREJAIL_VERSION="${arg#*=}"
      ;;
      --clean)
        CLEAN="true"
        echo "[ Warning ] --clean is not implemented yet"
      ;;
      --clean-all)
        CLEAN="true"
        CLEAN_ALL="true"
        echo "[ Warning ] --clean-all is not implemented yet"
      ;;
      --)
        break
      ;;
      --*|-?)
        echo "[ Warning ] unknow commandline argument: $arg"
      ;;
      *)
        TBB_PATH="$arg"
      ;;
    esac
  done

  if [ "$SHOW_HELP" == "true" ]; then
    usage
    exit
  fi
  if [ ! -v TBB_PATH ] && [ "$ONLY_UPDATE" == "false" ]; then
    echo "[ Error ] <PATH_TO_TOR_BROWSER_ARCHIV> not given"
    usage
    exit 1
  fi
  if [ ! -r "$TBB_PATH" ] && [ "$ONLY_UPDATE" == "false" ]; then
    echo "[ Error ] $TBB_PATH does not exist or is not readable"
    exit 1
  fi
  if [ -v FIREJAIL_VERSION ]; then
    if [ "$FIREJAIL_VERSION" != "0.9.60" ] && [ "$FIREJAIL_VERSION" != "0.9.58" ] && [ "$FIREJAIL_VERSION" != "0.9.62" ]; then
      echo "[ Error ] not supported firejail version: $FIREJAIL_VERSION"
      exit 1
    fi
    BASE_URL="$BASE_URL/stable-profiles/$FIREJAIL_VERSION"
  fi
}

main()
{
  parse_arguments "$@"
  prepare_filesystem
  extract "$TBB_PATH"
  download
  fix_disable-programs
  echo "[ Ok ] Done! The installation was successful, you can now launch the tor-browser by running:"
  echo "[ Ok ]   firejail --profile=firejailed-tor-browser \"\$HOME/Browser/start-tor-browser\""
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@";:
