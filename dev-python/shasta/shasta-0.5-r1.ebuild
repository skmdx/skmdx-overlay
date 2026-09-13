# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Shell abstract syntax tree library"
HOMEPAGE="https://github.com/binpash/shasta"
SRC_URI="https://github.com/binpash/shasta/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${PN}-${PV}-configure-roundtrip.patch" )

BDEPEND="test? ( dev-python/libdash[${PYTHON_USEDEP}] )"

EPYTEST_PLUGINS=()
# Static type checking is an upstream development check.
EPYTEST_DESELECT=(
	tests/tutorial_tests/test_popl26_tutorial.py::TestTypechecking
)
distutils_enable_tests pytest
