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

if [ "$1" == "--help" ]; then
	echo "USAGE"
	echo ""
	echo "    ./clean.sh [--all|--help]"
	echo ""
	echo " --help  show this help and exit"
	echo " --all   remove all files create by install.sh"
	echo ""
	echo "If no parameters are passed, only backups are deleted."
fi

if [ "$1" == "--all" ]; then
	rm -r -f -v "${HOME}"/.firejailed-tor-browser*
	rm -r -f -v "${HOME}"/.config/firejail/firejailed-tor-browser.profile*
	rm -r -f -v "${HOME}"/.local/share/applications/firejailed-tor-browser.desktop*
else
	rm -r -f -v "${HOME}"/.firejailed-tor-browser.bak-*
	rm -r -f -v "${HOME}"/.config/firejail/firejailed-tor-browser.profile.bak-*
	rm -r -f -v "${HOME}"/.local/share/applications/firejailed-tor-browser.desktop.bak-*
fi
