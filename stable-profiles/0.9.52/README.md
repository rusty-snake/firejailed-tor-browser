You need to add the following two statements:
'''
blacklist ${HOME}/.firejailed-tor-browser
blacklist ${HOME}/.config/firejail
'''
into `/etc/firejail/disable-programs.local` rather than `${HOME}/.config/firejail/disable-programs.local`.

Note: Make sure to verify the file permissions are set to 644. For example, in Ubuntu 18.04.5 LTS Use the command:
'''
sudo chmod 644 /etc/firejail/disable-programs.local
'''
then verify the change:
'''
$ ls -alh /etc/firejail/disable-programs.local
-rw-r--r-- 1 root root 77 Oct  6 07:16 /etc/firejail/disable-programs.local
'''
