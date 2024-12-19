# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="IBM Plex Mono と IBM Plex Sans JP を合成したプログラミングフォント PlemolJP (プレモル ジェイピー)"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"
SRC_URI="https://github.com/yuru7/PlemolJP/releases/download/v${PV}/PlemolJP_v${PV}.zip"

KEYWORDS="~amd64"
LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/PlemolJP_v${PV}"
FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/70-plemoljp.conf" )

src_install() {
    FONT_S="${S}/PlemolJP" font_src_install
    FONT_S="${S}/PlemolJP35" font_src_install
    FONT_S="${S}/PlemolJP35Console" font_src_install
    FONT_S="${S}/PlemolJPConsole" font_src_install
}
