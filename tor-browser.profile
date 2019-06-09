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

###########################################################
#                                                         #
#              HOWTO: Firejailed Tor Browser              #
#  https://github.com/rusty-snake/firejailed-tor-browser  #
#                                                         #
###########################################################

# Persistent local customizations
include tor-browser.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

blacklist /opt
blacklist /srv

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist ${HOME}/.tor-browser
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
# Cause some issues.
#ipc-namespace
# Disable sound, enable if you don't need
#machine-id
netfilter
# Disable hardware acceleration.
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
# @default without chroot and mincore
seccomp.drop @clock,@module,@raw-io,@reboot,@swap,@cpu-emulation,@debug,@obsolete,@resources,acct,bpf,mount,nfsservctl,pivot_root,setdomainname,sethostname,umount2,vhangup,add_key,fanotify_init,io_cancel,io_destroy,io_getevents,ioprio_set,io_setup,io_submit,kcmp,keyctl,name_to_handle_at,ni_syscall,open_by_handle_at,remap_file_pages,request_key,syslog,umount,userfaultfd,vmsplice
shell none
# Cause some issues.
#tracelog

disable-mnt
private-bin bash,cp,dirname,env,expr,file,getconf,gpg,grep,id,ln,mkdir,python*,readlink,rm,sed,sh,tail,tar,tclsh,test,xz
private-cache
private-dev
private-etc alsa,asound.conf,alternatives,ca-certificates,crypto-policies,fonts,hostname,hosts,ld.so.cache,machine-id,pki,pulse,resolv.conf,ssl
private-tmp

name tor-browser
#read-only ${HOME}
