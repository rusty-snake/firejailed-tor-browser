pp.awk
======

pp.awk is a minimal preprocessor, used to implement opt-in and opt-out features of the firejail profile.

Usage
-----

    ./pp.awk FEATURE1=<YES|NO> FEATURE2=<YES|NO> ... < <INPUT-FILE> > <OUTPUT-FILE>

Types of lines
--------------

There are three type of lines:

  1. Normal lines (every line not matching one of the conditions below) are included in the output file.
  2. pp.awk commands (lines starting with "#:" (without the quotes) are never in the output file.
  3. Conditional lines (lines between '#:if:' and '#:fi;' commands) are included in the output file if the conditions met.

pp.awk commands
---------------

Commands for pp.awk start with "#:" (without quotes), then comes the command e.g. "if",
followed by ": ARGs" or ";".

Commands
--------

 - `if: CONDITION` all following lines until `fi;` are only in the output file included if CONDITION is YES.
 - `else;` if CONDITION from the previous `if` was NO, include the lines from here, otherwise not include these lines.
 - `fi;` end of `if`

If a command is unknown, the program aborts.

Conditions
----------

Conditions are used by `if`, they are set on the commandline or in pp.awk.conditions.

Conditions may contain numbers, upper and lower case letters but
must begin with one letter. The assigned value of a Contition is
1/YES/TRUE or 0/NO/FALSE (case insensitive).

Conditions passed on the command line override the conditions specified in pp.awk.conditions.
Usage on the commandline: `./pp.awk CON1=VAL CON2=VAL`.

pp.awk.conditions sets the default conditions/values. The format is the following:

    # I'm a comment, because I start with "# " (note the space).
    CON1 VAL
    CON2 VAL

If a unknown conditions is used, the program aborts.

Examples
--------

firejailed-tor-browser.profile.in:

    disable-mnt
    #:if: PRIVATE
    private ${HOME}/.firejailed-tor-browser
    #:fi;
    private-dev


After `./pp.awk PRIVATE=NO < firejailed-tor-browser.private.in > firejailed-tor-browser.profile`
firejailed-tor-browser.profile looks:

    disable-mnt
    private-dev

After `./pp.awk PRIVATE=YES < firejailed-tor-browser.private.in > firejailed-tor-browser.profile`
firejailed-tor-browser.profile looks:

    disable-mnt
    private ${HOME}/.firejailed-tor-browser
    private-dev
