# Firejail profile for firejailed-tor-browser
# This file is overwritten after every install/update
# Persistent local customizations
include ${HOME}/.config/firejail/firejailed-tor-browser.local
# Persistent global definitions
include /etc/firejail/globals.local

# Note: PluggableTransports didn't work with this profile

noblacklist ${HOME}/.firejailed-tor-browser

blacklist /opt
blacklist /run/dbus/system_bus_socket
blacklist /srv
blacklist /usr/games
blacklist /usr/local
blacklist /usr/src

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.firejailed-tor-browser

# Add the next line to firejailed-tor-browser.local to enable better desktop integration.
#include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

#apparmor
caps.drop all
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
novideo
protocol unix,inet,inet6
#seccomp - replaced with seccomp.drop for Firefox 60
# @default-nodebuggers without chroot
seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@raw-io,@reboot,@resources,@swap,acct,add_key,bpf,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,open_by_handle_at,personality,pivot_root,process_vm_readv,ptrace,remap_file_pages,request_key,setdomainname,sethostname,syslog,umount2,userfaultfd,vhangup,vmsplice
seccomp.block-secondary
shell none
# Cause some issues
#tracelog

disable-mnt
private ${HOME}/.firejailed-tor-browser
private-bin bash,sh,grep,tail,env,expr,file,getconf,gpg,id,readlink,dirname,test,mkdir,python*,ln,sed,cp,rm,firejailed-tor-browser
private-dev
private-etc fonts
private-etc machine-id
private-tmp

name firejailed-tor-browser
noexec /dev/shm
noexec /tmp
