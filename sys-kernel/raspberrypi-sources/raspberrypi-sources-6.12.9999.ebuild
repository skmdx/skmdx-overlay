# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://github.com/raspberrypi/linux.git -> ${P}.git"
EGIT_CLONE_TYPE="shallow"
EGIT_BRANCH="rpi-${PV%.*}.y"

DESCRIPTION="Kernel source tree for Raspberry Pi-provided kernel builds"
HOMEPAGE="https://github.com/raspberrypi/linux"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	eapply_user
}

src_compile() {
	:;
}

src_install() {
	dodir /usr/src/
	cp -R "${S}/" "${D}/usr/src/linux-${PV%.*}-rpi" || die "Install failed!"
}
