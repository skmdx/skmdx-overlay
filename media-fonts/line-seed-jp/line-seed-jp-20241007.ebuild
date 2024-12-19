# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="LINE’s first custom typeface"
HOMEPAGE="https://github.com/line/seed"
SRC_URI="https://github.com/line/seed/releases/download/v${PV}/LINESeed-fonts.zip -> ${P}.zip"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/LINESeed-fonts"
FONT_S="${S}/LINESeedJP/fonts/otf"
FONT_SUFFIX="otf"
FONT_CONF=( "${FILESDIR}/70-line-seed-jp.conf" )
