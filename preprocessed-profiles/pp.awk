#!/usr/bin/awk -E

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

function errexit(msg) {
	print msg > "/dev/stderr"
	exit 1
}

function ckcon(con) {
	if (con in conditions == 0)
		errexit("Unknow condition")
	return con
}

BEGIN {
	# Parse pp.awk.conditions
	while ((getline < "pp.awk.conditions") > 0) {
		if ($1 == "#")
			continue
		if (NF > 2)
			errexit("To much rows")
		if ($1 !~ /^[A-Za-z][0-9A-Za-z]+$/)
			errexit("Invalid character in condition")

		con = $1
		val = $2
		if (toupper(val) ~ /(YES|TRUE|1)/) {
			conditions[con] = 1
		} else if (toupper(val) ~ /(NO|FALSE|0)/) {
			conditions[con] = 0
		} else {
			errexit("Invalid value")
		}
	} close("pp.awk.conditions")

	# Parse commandline arguments
	for (arg in ARGV) {
		if (toupper(ARGV[arg]) ~ /^[A-Z][0-9A-Z]+=(YES|TRUE|1)$/) {
			conditions[gensub(/=.*/, "", 1, ARGV[arg])] = 1
		} else if (toupper(ARGV[arg]) ~ /^[A-Z][0-9A-Z]+=(NO|FALSE|0)$/) {
			conditions[gensub(/=.*/, "", 1, ARGV[arg])] = 0
		} else {
			if (ARGV[arg] == "awk")
				continue
			errexit("Invalid commandline argument")
		}
		ARGV[arg] = ""
	}

	include_line = 1
	forward2fi = 0
	last_cmd = "fi"
}
/^#:.*/ {
	match($0, /:(if|elif|else|fi)(:|;)/)
	switch (substr($0, RSTART, RLENGTH))  {
		case ":if:":
			if (last_cmd != "fi") {
				errexit("syntax error in line " NR)
			}
			if (conditions[ckcon(substr($0, RSTART + RLENGTH + 1))]) {
				include_line = 1
				forward2fi = 1
			} else {
				include_line = 0
			}
			last_cmd = "if"
			break
		case ":elif:":
			if (last_cmd != "if" && last_cmd != "elif") {
				errexit("syntax error in line " NR)
			}
			if (forward2fi == 0 && conditions[ckcon(substr($0, RSTART + RLENGTH + 1))]) {
				include_line = 1
				forward2fi = 1
			} else {
				include_line = 0
			}
			last_cmd = "elif"
			break
		case ":else;":
			if (last_cmd != "if" && last_cmd != "elif") {
				errexit("syntax error in line " NR)
			}
			if (forward2fi == 0) {
				include_line = 1
				forward2fi = 1
			} else {
				include_line = 0
			}
			last_cmd = "else"
			break
		case ":fi;":
			if (last_cmd != "if" && last_cmd != "elif" && last_cmd != "else") {
				errexit("syntax error in line " NR)
			}
			include_line = 1
			forward2fi = 0
			last_cmd = "fi"
			break
		default:
			errexit("Unknow command in line " NR)
	}
}
!/^#:.*/ {
	if (include_line)
		print
}
# TODOs
#:ifn: CON
#:elifn: CON
