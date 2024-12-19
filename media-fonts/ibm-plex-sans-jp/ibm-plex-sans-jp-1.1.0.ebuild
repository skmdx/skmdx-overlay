# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="A set of OpenType/CFF Pan-CJK fonts"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"
SRC_URI="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-jp%40${PV}/${PN}.zip -> ${P}.zip"

KEYWORDS="~amd64"
LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"
FONT_S="${S}/fonts/complete/otf/unhinted"
FONT_SUFFIX="otf"
FONT_CONF=( "${FILESDIR}/70-ibm-plex-sans-jp.conf" )
