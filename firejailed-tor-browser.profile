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

###########################################################
#                                                         #
#              HOWTO: Firejailed Tor Browser              #
#  https://github.com/rusty-snake/firejailed-tor-browser  #
#                                                         #
###########################################################

# Report any issues at
#  <https://github.com/rusty-snake/firejailed-tor-browser/issues/new>

# Persistent local customizations
include firejailed-tor-browser.local
# Persistent global definitions
include globals.local

# Note: PluggableTransports didn't work with this profile

ignore noexec ${HOME}

noblacklist ${HOME}/.firejailed-tor-browser

blacklist /opt
blacklist /srv
blacklist /sys
blacklist /usr/games
blacklist /usr/local
blacklist /usr/src
blacklist /var

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist ${HOME}/.firejailed-tor-browser
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc

apparmor
caps.drop all
#hostname host
# causes some graphics issues
ipc-namespace
# Breaks sound; enable it if you don't need sound
#machine-id
netfilter
# Disable hardware acceleration
#no3d
nodvd
nogroups
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
# Cause some issues
#tracelog

disable-mnt
private ${HOME}/.firejailed-tor-browser
# These are the minimum required programms to start the TBB,
# you maybe need to add one or more programs from the commented private-bin line below.
# To get full support of the scripts start-tor-browser, execdesktop and firefox
# (this is a wrapper script, the firefox browser executable is firerfox.real) in the TBB,
# add the commented private-bin line to firejailed-tor-browser.local
private-bin bash,dirname,env,expr,file,grep,rm,sh,tclsh
#private-bin cat,cp,cut,getconf,id,kdialog,ln,mkdir,pwd,readlink,realpath,sed,tail,test,update-desktop-database,xmessage,xmessage,zenity
private-cache
private-dev
# This is a minimal private-etc, if there are breakages due it you need to add more files.
# To get ideas what maybe needs to be added look at the templates:
# https://github.com/netblue30/firejail/blob/28142bbc49ecc3246033cbc810d7f04027c87f4d/etc/templates/profile.template#L151-L162
private-etc machine-id
# On Arch you maybe need to uncomment the following (or add to your firejailed-tor-browser.local).
# See https://github.com/netblue30/firejail/issues/3158
#private-etc ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload
# Experimental
#private-lib libX11-xcb.so.1,libXt.so.6
private-tmp

dbus-user none
dbus-system none

name firejailed-tor-browser
