#!/usr/bin/env bash

# MIT License
#
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

# Exit on error
set -e

# repo url for downloading the files
REPO_DATA_BASE_URL="https://raw.githubusercontent.com/rusty-snake/firejailed-tor-browser/master"
# message prefix: Prefix for outout of this script
MSG_PRFX="install_FTB.sh: "

# Rename a file/dir instead of overwriting
function dont_overwrite_file {
	if [ -e $1 ]; then
		echo "${MSG_PRFX}Warning: $1 already exists, renaming to $1.bak."
		mv -v -T $1 $1.bak
	fi
}

# Make sure that we are in $HOME
cd

# Make sure .tor-browser can be used
dont_overwrite_file .tor-browser

# The tor browser will be installed in ~/.tor-browser.
mkdir .tor-browser
echo "${MSG_PRFX}Info: directory ${HOME}/.tor-browser created"

# We need tar to extract the tor browser
if [ -z `which tar` ]; then
	echo "${MSG_PRFX}Error: Please install tar."
	exit 1
fi

# tar extract to ., so we need to go to .tor-browser
cd .tor-browser

# FIXME: Don't hardcode the filename

# Extract the Tor Brower to ~/.tor-browser
echo "${MSG_PRFX}Info: Extracting the tor browser ..."
tar -xJf $HOME/Downloads/tor-browser-linux64-8.5_en-US.tar.xz
echo "${MSG_PRFX}Info: tor browser is extracted"

# Fix the directory structure.
mv tor-browser_en-US/* .
rmdir tor-browser_en-US
echo "${MSG_PRFX}Info: directory structure in $HOME/.tor-browser fixed"

# go back to $HOME
cd

# Make sure that these directorys exists
mkdir -v -p $HOME/.config/firejail
mkdir -v -p $HOME/.local/share/applications

# Make sure that these file can be used safely.
dont_overwrite_file $HOME/.config/firejail/tor-browser.profile
dont_overwrite_file $HOME/.local/share/applications/tor-browser.desktop

# Downloading the files using wget if it is installed
if [ -n `which wget` ]; then
	echo "${MSG_PRFX}Info: Using wget for downloading."
	# Download the firejail profile
	echo "${MSG_PRFX}Info: Downloading the firejail profile ..."
	# HACK: writing to stdout and redirecting to prevent permission error when wget is firejailed.
	wget ${REPO_DATA_BASE_URL}/tor-browser.profile -O - > ~/.config/firejail/tor-browser.profile
	# Downlaod the .desktop file and fix the paths in the file.
	echo "${MSG_PRFX}Info: Downloading the .desktop file ..."
	wget -O - ${REPO_DATA_BASE_URL}/tor-browser.desktop | sed "s/USER/$USER/g" > $HOME/.local/share/applications/tor-browser.desktop
else 
	# Try to download with curl if wget isn't installed
	if [ -n `which curl` ]; then
		echo "${MSG_PRFX}Info: Using curl for downloading."
		# Download the firejail profile
		echo "${MSG_PRFX}Info: Downloading the firejail profile ..."
		curl ${REPO_DATA_BASE_URL}/tor-browser.profile -O ~/.config/firejail/tor-browser.profile
		# Downlaod the .desktop file and fix the paths in the file.
		echo "${MSG_PRFX}Info: Downloading the .desktop file ..."
		curl ${REPO_DATA_BASE_URL}/tor-browser.desktop | sed "s/USER/$USER/g" > $HOME/.local/share/applications/tor-browser.desktop
	else
		# We _need_ wget or curl
		echo "${MSG_PRFX}Error: Please install wget or curl."
		exit 1
	fi
fi

echo "${MSG_PRFX}Finish."
