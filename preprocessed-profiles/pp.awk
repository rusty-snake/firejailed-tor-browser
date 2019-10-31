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
	while ((getline < "pp.awk.conditions") > 0) {
		if ($1 == "#") { continue }
		if (NF > 2) {
			print "To much rows" > "/dev/stderr"
			exit 1
		}
		if ($1 !~ /^[A-Za-z][0-9A-Za-z]+$/) {
			print "Invalid character in condition" > "/dev/stderr"
			exit 1
		}
		if (toupper($2) ~ /(YES|TRUE|1)/) {
			conditions[$1] = 1
		} else { if (toupper($2) ~ /(NO|FALSE|0)/) {
			conditions[$1] = 0
		} else {
			print "Invalid value" > "/dev/stderr"
			exit 1
		}}
	} close("pp.awk.conditions")
	for (arg in ARGV) {
		if (toupper(ARGV[arg]) ~ /^[A-Z][0-9A-Z]+=(YES|TRUE|1)$/) {
			conditions[gensub(/=.*/, "", 1, ARGV[arg])] = 1
		} else { if (toupper(ARGV[arg]) ~ /^[A-Z][0-9A-Z]+=(NO|FALSE|0)$/) {
			conditions[gensub(/=.*/, "", 1, ARGV[arg])] = 0
		} else {
			if (ARGV[arg] == "awk") { continue }
			print "Invalid conditions/value" > "/dev/stderr"
			exit 1
		}}
		ARGV[arg] = ""
	}
	include_line = 1
	forward2fi = 0
	conditional_context = 0
}
/^#:.*/ {
	match($0, /:(if|else|fi)(:|;)/)
	switch (substr($0, RSTART, RLENGTH))  {
		case ":if:":
			if (conditional_context == 1) {
				print "Nesting isn't allowed" > "/dev/stderr"
				exit 1
			}
			if (conditions[ckcon(substr($0, RSTART + RLENGTH + 1))]) {
				include_line = 1
				forward2fi = 1
			} else {
				include_line = 0
			}
			conditional_context = 1
			break
		case ":else;":
			check_concon()
			if (forward2fi == 0) {
				include_line = 1
				forward2fi = 1
			} else {
				include_line = 0
			}
			break
		case ":fi;":
			check_concon()
			include_line = 1
			forward2fi = 0
			conditional_context = 0
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
function ckcon(con) {
	if (con in conditions == 0) {
		print "Unknow condition" > "/dev/stderr"
		exit 1
	}
	return con
}
function check_concon() {
	if (conditional_context == 0) {
		print "No conditional_context" > "/dev/stderr"
		exit 1
	}
}
# TODOs
#:ifn: CON
#:elif: CON
#:elifn: CON
