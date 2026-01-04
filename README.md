# Personal Gentoo Overlay
## Packages
- app-i18n/cskk
- app-i18n/fcitx-cskk
- app-pda/adbfs-rootless
- dev-python/ariblib
- dev-python/libusb-package
- gui-apps/gnome-randr-rust
- media-fonts/ibm-plex-sans-jp
- media-fonts/line-seed-jp
- media-fonts/plemoljp
- media-libs/glfw-9999
- media-libs/libaribb25
- media-libs/libaribcaption
- media-tv/ISDBScanner
- media-tv/recisdb
- media-tv/tsduck
- media-video/ffmpeg (with libaribcation support)
- net-wireless/bluez-9999
- sys-kernel/raspberrypi-sources
- x11-themes/QAdwaitaDecorations

## Install
```
eselect repository add skmdx-overlay git https://github.com/skmdx/skmdx-overlay.git
emaint -r skmdx-overlay sync
```
