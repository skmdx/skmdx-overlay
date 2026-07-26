# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

COMMIT="be1872568730cc994108f1690101661edd3a0061"

DESCRIPTION="VA-API image thumbnailer compatible with gdk-pixbuf-thumbnailer"
HOMEPAGE="https://github.com/skmdx/vaapi-thumbnailer"
SRC_URI="https://github.com/skmdx/vaapi-thumbnailer/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.56:2
	>=media-libs/libheif-1.16:=
	media-libs/libexif
	>=media-video/ffmpeg-4.0:=[vaapi]
	>=x11-libs/gdk-pixbuf-2.36.5:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
