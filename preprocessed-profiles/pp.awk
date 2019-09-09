#!/usr/bin/awk -E

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

BEGIN {
	PRIVATE = "YES"
	for (arg in ARGV) {
		if (ARGV[arg] ~ /^PRIVATE=(YES|NO)$/) {
			PRIVATE = substr(ARGV[arg], 9)
		}
		ARGV[arg] = ""
	}
	include_line = 1
}
/^#:.*/ {
	match($0, /:(if|fi)(:|;)/)
	switch (substr($0, RSTART, RLENGTH))  {
		case ":if:":
			switch (substr($0, RSTART + RLENGTH + 1)) {
				case "PRIVATE":
					if (PRIVATE == "NO") {
						include_line = 0
					}
					break
				default:
					print "Unknow condition" > "/dev/stderr"
					exit 1
			}
			break
		case ":fi;":
			include_line = 1
			break
		default:
			print "Unknow command" > "/dev/stderr"
			exit 1
	}
}
!/^#:.*/ {
	if (include_line) {
		print
	}
}
# TODOs
# - nesting (or deny nesting)
# - else
# - not
