# shellcheck shell=bash

# Copyright © 2019-2021 rusty-snake and contributors
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

FTB_HOME="$HOME/.firejailed-tor-browser"
FTB_DESKTOP="firejailed-tor-browser.desktop"
FTB_DESKTOP_DEST="${XDG_DATA_HOME:-"$HOME"/.local/share}/applications/$FTB_DESKTOP"
FTB_LOCAL="firejailed-tor-browser.local"
FTB_PROFILE="firejailed-tor-browser.profile"
FTB_X11_INC="firejailed-tor-browser-x11.inc"
SUPPORTED_FIREJAIL_VERSIONS=("git" "0.9.66" "0.9.64.4" "0.9.62" "0.9.58" "0.9.52")

CFG_FIREJAIL_VERSION="git"
CFG_SRC="."
CFG_TBB_PATH="PATH_TO_TOR_BROWSER_ARCHIVE"
CFG_X11=no
if [[ -z "$WAYLAND_DISPLAY" ]]; then
  echo "[ Info ] \$WAYLAND_DISPLAY is unset (or empty). Allow X11."
  CFG_X11=yes
fi


usage()
{
  cat <<-EOM
Usage:
    $0 [OPTIONS] [PATH_TO_TOR_BROWSER_ARCHIVE]

OPTIONS:
  --help,-h,-?        Show this help and exit.
  --firejail=VERSION  Specify firejail version (default: git)
                       supported versions: ${SUPPORTED_FIREJAIL_VERSIONS[@]}
  --x11               Allow X11 and do not force Wayland
EOM
  exit 0
}

parse_arguments()
{
  for arg in "$@"; do
    case $arg in
      --help|-h|-\?)
        usage
      ;;
      --firejail=*)
        CFG_FIREJAIL_VERSION="${arg#*=}"
      ;;
      --x11)
        CFG_X11=yes
      ;;
      --*|-?)
        echo "[ Warning ] Unknow commandline argument: $arg"
      ;;
      *)
        CFG_TBB_PATH="$arg"
        break
      ;;
    esac
  done

  check_firejail_version
}

create_backup()
{
  # Move $1 to $1.bak-NOW if it exist
  if [[ -e "$1" ]]; then
    mv "$1" "$1.bak-$(date --iso-8601=seconds)"
    echo "[ Ok ] Created backup of '$1'."
  fi
}

check_firejail_version()
{
  if [[ "$CFG_FIREJAIL_VERSION" == "git" ]]; then
    return 0
  fi

  supported=false
  for version in "${SUPPORTED_FIREJAIL_VERSIONS[@]}"; do
    if [[ "$CFG_FIREJAIL_VERSION" == "$version" ]]; then
      supported=true
      CFG_SRC="./stable-profiles/$CFG_FIREJAIL_VERSION"
      break
    fi
  done

  if [[ "$supported" == "false" ]]; then
    echo "[ Error ] Unsupported firejail version '$CFG_FIREJAIL_VERSION'."
    exit 1
  fi
}

fix_disable-programs()
{
  if [[ "$FIREJAIL_VERSION" == "0.9.58" || "$FIREJAIL_VERSION" == "0.9.52" ]]; then
    echo "[ Warning ] Fixing disbale-programs is only supported for firejail 0.9.60 and newer."
    echo "[ Info ] To fix disable-programs manualy execute the following as root if you know what it does:"
    echo "[ Info ]     sh -c 'echo \${HOME}/.firejailed-tor-browser' >> /etc/firejail/disable-programs.local"
    return 0
  fi

  DISABLE_PROGRAMS_LOCAL="${HOME}/.config/firejail/disable-programs.local"
  BLACKLIST_FTB="blacklist \${HOME}/.firejailed-tor-browser"

  # grep prints errors about non-existing files even with --quiet
  touch "$DISABLE_PROGRAMS_LOCAL"

  # Add $BLACKLIST_FTB to disable-programs.inc unless it's present.
  if ! grep --quiet "$BLACKLIST_FTB" "$DISABLE_PROGRAMS_LOCAL"; then
    echo "$BLACKLIST_FTB" >> "$DISABLE_PROGRAMS_LOCAL"
    echo "[ Ok ] Fixed disbale-programs.inc."
  fi
}

allow_x11_if_wanted()
{
  if [[ "$CFG_X11" != "yes" ]]; then
    return
  fi

  touch "$HOME/.config/firejail/$FTB_LOCAL"

  INCLUDE_FTB_X11_INC="include firejailed-tor-browser-x11.inc"

  if ! grep --quiet "^$INCLUDE_FTB_X11_INC" "$HOME/.config/firejail/$FTB_LOCAL"; then
    echo "$INCLUDE_FTB_X11_INC" >> "$HOME/.config/firejail/$FTB_LOCAL"
    echo "[ Ok ] Allowed X11."
  fi
}


install_fj()
{
  create_backup "$HOME/.config/firejail/$FTB_PROFILE"
  install -Dm0644 "$CFG_SRC/$FTB_PROFILE" "$HOME/.config/firejail/$FTB_PROFILE"
  echo "[ Ok ] Installed $FTB_PROFILE."

  if [[ -e "$CFG_SRC/$FTB_X11_INC" ]]; then
    create_backup "$HOME/.config/firejail/$FTB_X11_INC"
    install -Dm0644 "$CFG_SRC/$FTB_X11_INC" "$HOME/.config/firejail/$FTB_X11_INC"
    echo "[ Ok ] Installed $FTB_X11_INC."
  fi

  fix_disable-programs
  allow_x11_if_wanted
}

install_de()
{
  create_backup "$FTB_DESKTOP_DEST"
  mkdir -v -p "$(dirname "$FTB_DESKTOP_DEST")"
  sed "s,HOME,$HOME,g" < "$CFG_SRC/$FTB_DESKTOP.in" > "$FTB_DESKTOP_DEST"
  echo "[ Ok ] Installed $FTB_DESKTOP."
}

# vim: ft=bash sw=4 ts=4 sts=4 et ai
