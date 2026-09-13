# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit autotools distutils-r1 pypi toolchain-funcs

DESCRIPTION="Python bindings for the dash shell parser"
HOMEPAGE="https://github.com/binpash/libdash"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${PN}-external-build.patch" )

src_prepare() {
	distutils-r1_src_prepare
	eautoreconf
}

src_configure() {
	tc-export CC AR RANLIB
	econf --disable-static
}

src_compile() {
	# Explicit library targets do not trigger Automake BUILT_SOURCES.
	emake -C src builtins.h nodes.h syntax.h token.h token_vars.h
	emake -C src dlldash.la
	cp src/.libs/dlldash.so libdash/libdash.so || die
	distutils-r1_src_compile
}
