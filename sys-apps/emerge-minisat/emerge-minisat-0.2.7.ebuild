# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Portage emerge with SAT dependency resolution"
HOMEPAGE="https://github.com/skmdx/skmdx-overlay"
SRC_URI="https://github.com/skmdx/skmdx-overlay/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-mathematics/minisat:=
	$(python_gen_cond_dep '
		>=dev-python/python-sat-1.9_pre16[${PYTHON_USEDEP}]
		>=sys-apps/portage-3.0.66.1[${PYTHON_USEDEP}]
	')
"
DEPEND="sci-mathematics/minisat:="
BDEPEND="$(python_gen_cond_dep '>=dev-python/setuptools-77[${PYTHON_USEDEP}]')"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# Respect the user's optimization flags for the native extension.
	sed -i '/extra_compile_args=/d' setup.py || die
}

python_test() {
	# CLI integration tests execute ebuild phases and require an isolated ROOT.
	# They are run separately against the installed command.
	cd "${T}" || die
	epytest "${S}/tests" --ignore="${S}/tests/test_cli.py"
}
