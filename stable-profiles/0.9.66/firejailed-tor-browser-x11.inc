# vim: ft=firejail
ignore env DISPLAY=wayland_is_better
ignore rmenv XAUTHORITY
ignore hostname

noblacklist /tmp/.X11-unix
noblacklist ${HOME}/.Xauthority
noblacklist ${RUNUSER}/gdm/Xauthority
noblacklist ${RUNUSER}/.mutter-Xwaylandauth*
noblacklist ${RUNUSER}/xauth_*
noblacklist /tmp/xauth*
noblacklist /tmp/.ICE-unix
noblacklist ${RUNUSER}/ICEauthority
