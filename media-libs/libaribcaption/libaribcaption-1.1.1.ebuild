# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Portable ARIB STD-B24 Caption Decoder/Renderer"
HOMEPAGE="https://github.com/xqq/libaribcaption"
SRC_URI="https://github.com/xqq/libaribcaption/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/freetype[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DARIBCC_SHARED_LIBRARY=ON
		-DARIBCC_NO_EXCEPTIONS=ON
		-DARIBCC_NO_RTTI=ON

	)
	cmake-multilib_src_configure
}
