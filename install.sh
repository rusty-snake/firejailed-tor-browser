#!/usr/bin/env bash

# Copyright (c) 2019 rusty-snake (https://github.com/rusty-snake) <print_hello_world+License@protonmail.com>
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

function backup_file {
	[ ! -e "$1" ] || mv "$1" "$1.bak-$(date --iso-8601=seconds)"
	echo "[ Ok ] backup of $1 created"
}

function download_with_wget {
	wget -O - "${BASE_URL}/${FJ_PROFILE}" 2>/dev/null > "${HOME}/.config/firejail/${FJ_PROFILE}"
	echo "[ Ok ] firejail profile for firejailed-tor-browser downloaded"
	wget -O - "${BASE_URL}/${DESKTOP_FILE}" 2>/dev/null | sed "s,HOME,${HOME},g" > "${HOME}/.local/share/applications/${DESKTOP_FILE}"
	echo "[ Ok ] firejailed-tor-browser.desktop downloaded"
}

function download_with_curl {
	curl "${BASE_URL}/${FJ_PROFILE}" 2>/dev/null > "${HOME}/.config/firejail/${FJ_PROFILE}"
	echo "[ Ok ] firejail profile for firejailed-tor-browser downloaded"
	curl "${BASE_URL}/${DESKTOP_FILE}" 2>/dev/null | sed "s,HOME,${HOME},g" > "${HOME}/.local/share/applications/${DESKTOP_FILE}"
	echo "[ Ok ] firejailed-tor-browser.desktop downloaded"
}

function download {
	[ -n "$(command -v wget)" ] && download_with_wget && return 0
	[ -n "$(command -v curl)" ] && download_with_curl && return 0
	return 1
}

function fix_disable-programs {
	echo 'blacklist ${HOME}/.firejailed-tor-browser' >> "${HOME}/.config/firejail/disbale-programs.local"
	echo "[ Ok ] disbale-programs fixed"
}

function extract {
	echo "[ Info ] extracting the tor-browser ..."
	tar -C "${HOME}/.firejailed-tor-browser" --strip 1 -xJf "$1"
	echo "[ Ok ] tor-browser extracted"
}

function prepare_filesystem {
	backup_file "${HOME}/.firejailed-tor-browser"
	mkdir "${HOME}/.firejailed-tor-browser"

	mkdir -v -p "${HOME}/.config/firejail"
	backup_file "${HOME}/.config/firejail/${FJ_PROFILE}"

	mkdir -v -p "${HOME}/.local/share/applications"
	backup_file "${HOME}/.local/share/applications/${DESKTOP_FILE}"

	echo "[ Ok ] filesystem prepared"
}

function main {
	prepare_filesystem
	extract "$1"
	download
	fix_disable-programs
}

main "$@"
echo "[ Ok ] Done! The installation was successful, you can now launch the tor-browser by running"
echo "[ Ok ]   'firejail --profile=firejailed-tor-browser \"\$HOME/Browser/start-tor-browser\"'."
