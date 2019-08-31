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

###########################################################
#                                                         #
#              HOWTO: Firejailed Tor Browser              #
#  https://github.com/rusty-snake/firejailed-tor-browser  #
#                                                         #
###########################################################

#
# Backported profile for firejail 0.9.58
#

# Persistent local customizations
include firejailed-tor-browser.local
# Persistent global definitions
include globals.local

# Note: PluggableTransports didn't work with this profile

noblacklist ${HOME}/.firejailed-tor-browser

blacklist /opt
blacklist /run/dbus/system_bus_socket
blacklist /srv
blacklist /usr/games
blacklist /usr/local
blacklist /usr/src

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.firejailed-tor-browser
# Add the next line to firejailed-tor-browser.local to enable better desktop integration
#include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
#hostname host
# Cause some issues
#ipc-namespace
# Breaks sound; enable it if you don't need sound
#machine-id
netfilter
# Disable hardware acceleration
#no3d
nodbus
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
# @default-nodebuggers without chroot
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
seccomp.block-secondary
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
private-tmp

name firejailed-tor-browser
noexec ${RUNUSER}
noexec /dev/shm
noexec /tmp