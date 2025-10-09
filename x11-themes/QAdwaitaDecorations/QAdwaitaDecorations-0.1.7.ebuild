# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Qt decoration plugin implementing Adwaita-like client-side decorations."
HOMEPAGE="https://github.com/FedoraQt/QAdwaitaDecorations"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FedoraQt/QAdwaitaDecorations.git"
else
	SRC_URI="https://github.com/FedoraQt/QAdwaitaDecorations/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="qt5 +qt6"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
	qt5? (
		>=dev-qt/qtcore-5.15.2:5
		>=dev-qt/qtgui-5.15.2:5
		>=dev-qt/qtsvg-5.15.2:5
		>=dev-qt/qtwayland-5.15.2:5
		>=dev-qt/qtwidgets-5.15.2:5
	)
	qt6? (
		>=dev-qt/qtbase-6.5.0:6[gui,widgets,wayland]
		>=dev-qt/qtsvg-6.5.0:6
		>=dev-qt/qtwayland-6.5.0:6
	)
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_configure() {
	if use qt5; then
		BUILD_DIR="${WORKDIR}/${PN}_qt5"
		local mycmakeargs=(
			-DUSE_QT6=OFF
		)
		cmake_src_configure
	fi
	if use qt6; then
		BUILD_DIR="${WORKDIR}/${PN}_qt6"
		local mycmakeargs=(
			-DUSE_QT6=ON
		)
		cmake_src_configure
	fi
}

src_compile() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake_src_compile -C "${_d}"
	done
}

src_install() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake_src_install -C "${_d}"
	done
}
