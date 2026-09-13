# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Python bindings for the Bash shell parser"
HOMEPAGE="https://github.com/binpash/libbash"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${PN}-external-build.patch" )

src_configure() {
	tc-export CC AR RANLIB
	cd libbash/bash-5.2 || die
	econf --without-bash-malloc --disable-nls --disable-readline
}

src_compile() {
	emake -C libbash/bash-5.2
	distutils-r1_src_compile
}
