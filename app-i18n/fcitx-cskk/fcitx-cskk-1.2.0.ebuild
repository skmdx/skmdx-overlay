# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

DESCRIPTION="SKK input method plugin for fcitx5 that uses LibCSKK"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-cskk"

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcitx/fcitx5-cskk"
else
	KEYWORDS="~amd64 ~x86"
	MY_PN="fcitx5-cskk"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="https://github.com/fcitx/fcitx5-cskk/archive/refs/tags/v${PV}.tar.gz"
fi

LICENSE="GPL-3+"
SLOT="5"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-i18n/fcitx:5
		>=app-i18n/cskk-3.0.0
		>=dev-qt/qtcore-5.7.0:5
		app-i18n/fcitx-qt[qt5,-onlyplugin]
		app-i18n/skk-jisyo
		sys-devel/gettext"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake_src_configure
}
