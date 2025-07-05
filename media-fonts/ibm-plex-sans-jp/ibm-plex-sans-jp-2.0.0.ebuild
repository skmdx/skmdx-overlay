# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="The package of IBM’s typeface, IBM Plex."
HOMEPAGE="https://github.com/IBM/plex/"
SRC_URI="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-jp%40${PV}/${PN}.zip -> ${P}.zip"

KEYWORDS="~amd64"
LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"
FONT_S="${S}/fonts/complete/otf/unhinted"
FONT_SUFFIX="otf"
FONT_CONF=( "${FILESDIR}/70-ibm-plex-sans-jp.conf" )
