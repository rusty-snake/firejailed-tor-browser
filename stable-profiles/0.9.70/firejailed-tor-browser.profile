# vim: ft=firejail
# Copyright © 2019-2022 rusty-snake and contributors
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

###########################################################
#                                                         #
#              HOWTO: Firejailed Tor Browser              #
#  https://github.com/rusty-snake/firejailed-tor-browser  #
#                                                         #
###########################################################

#
# Backported profile for firejail 0.9.70
#

# Report any issues at
#  <https://github.com/rusty-snake/firejailed-tor-browser/issues/new>

# Persistent local customizations
include firejailed-tor-browser.local

# Note: PluggableTransports didn't work with this profile

# If you use X11:
#include firejailed-tor-browser-x11.inc

# If you use pulseaudio:
#ignore machine-id
#noblacklist /etc
#private-etc machine-id

ignore noexec ${HOME}

noblacklist ${HOME}/.firejailed-tor-browser

include allow-bin-sh.inc

blacklist /etc
blacklist /opt
blacklist /srv
blacklist /sys
blacklist /tmp
blacklist /usr/games
blacklist /usr/libexec
blacklist /usr/local
blacklist /usr/src
blacklist /var

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

whitelist /run/user
whitelist ${RUNUSER}/pulse/native
whitelist ${RUNUSER}/wayland-0
whitelist /usr/share/glib-2.0/schemas/gschemas.compiled
whitelist /usr/share/icons/Adwaita
whitelist /usr/share/mime/magic
whitelist /usr/share/misc/magic
whitelist /usr/share/X11/xkb

caps.drop all
hostname host
ipc-namespace
machine-id
netfilter
# Disable hardware acceleration
#no3d
nodvd
nogroups
noinput
nonewprivs
noroot
# Disable sound, enable if you don't need
#nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp !chroot,@memlock,@setuid,@timer,io_pgetevents
seccomp.block-secondary
seccomp-error-action kill
shell none

disable-mnt
private ${HOME}/.firejailed-tor-browser
private-bin bash,dirname,env,expr,file,getconf,grep,rm,sh
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

env GTK_THEME=Adwaita
env MOZ_ENABLE_WAYLAND=1
name firejailed-tor-browser
read-only ${HOME}
read-write ${HOME}/Browser
