# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Shell expansion library for shell abstract syntax trees"
HOMEPAGE="https://github.com/binpash/sh-expand"
SRC_URI="https://github.com/binpash/sh-expand/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pexpect[${PYTHON_USEDEP}]
	dev-python/shasta[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		app-shells/bash
		dev-python/libbash[${PYTHON_USEDEP}]
		dev-python/libdash[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	"${EPYTHON}" run_tests.py || die "Shell expansion tests failed"
}
