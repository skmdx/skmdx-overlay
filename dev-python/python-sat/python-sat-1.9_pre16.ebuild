# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PV=${PV/_pre/.dev}

inherit distutils-r1 pypi toolchain-funcs

DESCRIPTION="Python toolkit for SAT-based prototyping"
HOMEPAGE="https://pysathq.github.io/ https://github.com/pysathq/pysat"
MINISATEP_COMMIT=90305f7b9ab9c9c9c560238f16b47c26506d0750
SRC_URI+="
	https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.4.tar.gz -> kissat-4.0.4.gh.tar.gz
	https://github.com/hchenqide/minisat/archive/${MINISATEP_COMMIT}.tar.gz -> minisatep-${MINISATEP_COMMIT}.gh.tar.gz
"

LICENSE="MIT glucose41? ( Glucose-Syrup )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="glucose41"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="sys-devel/patch"

PATCHES=( "${FILESDIR}/${PN}-1.9-build.patch" )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	if ! use glucose41; then
		# Glucose/Gluecard 4.1 carry an additional competition-use restriction.
		# Exclude their test matrix entries along with the optional backends.
		sed -i -E "s/'(glucose41|gluecard41|g41|gc41|g4|gc4)', *//g" \
			setup.py tests/test_*.py || die
	fi

	# These two archives are absent from the sdist. Fetch them through Portage.
	cp "${DISTDIR}/kissat-4.0.4.gh.tar.gz" solvers/kissat404.tar.gz || die
	cp "${DISTDIR}/minisatep-${MINISATEP_COMMIT}.gh.tar.gz" solvers/minisatep.tar.gz || die
	sed -i 's@solvers/minisatep.zip@solvers/minisatep.tar.gz@' solvers/prepare.py || die

	# Keep upstream's required flags while respecting the user's toolchain.
	sed -i \
		-e '/^+\(CC\|CXX\) *:=/s/:=/?=/' \
		-e '/^+\(CFLAGS\|CXXFLAGS\) *:=/s/:=/+=/' \
		-e '/^+\(COPT\|CXXOPT\) *:=/s/ -O3//' \
		-e 's/@-ar cr /$(AR) cr /' \
		solvers/patches/*.patch || die
}

src_configure() {
	tc-export CC CXX AR
	distutils-r1_src_configure
}

python_test() {
	# The source tree keeps pysat.examples outside the pysat directory.
	cd "${T}" || die
	epytest "${S}/tests"
}
