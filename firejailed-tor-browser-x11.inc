ignore env MOZ_ENABLE_WAYLAND=1
ignore env DISPLAY=wayland_is_better
ignore blacklist /tmp/.X11-unix
ignore rmenv DISPLAY
ignore rmenv XAUTHORIT
ignore include disable-X11.inc
include whitelist-runuser-common.inc
