noblacklist /tmp/.X11-unix
include whitelist-runuser-common.inc
ignore env MOZ_ENABLE_WAYLAND=1
ignore env DISPLAY=wayland_is_better
ignore rmenv DISPLAY
ignore rmenv XAUTHORIT
