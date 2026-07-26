# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

COMMIT="32cacccb4c3a0c4cbed30c613c1f5602bc3214af"

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
	>=media-video/ffmpeg-7.0:=[vaapi]
	>=x11-libs/gdk-pixbuf-2.36.5:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
