# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 toolchain-funcs

DGSH_COMMIT=83f817fed23445c59405b250774efde3bec7ba72

DESCRIPTION="Light-touch data-parallel shell processing"
HOMEPAGE="https://github.com/binpash/pash"
SRC_URI="
	https://github.com/binpash/pash/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/binpash/dgsh/archive/${DGSH_COMMIT}.tar.gz -> dgsh-${DGSH_COMMIT}.gh.tar.gz
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/graphviz[${PYTHON_USEDEP}]
		>=dev-python/libdash-0.5.1[${PYTHON_USEDEP}]
		>=dev-python/libbash-0.1.14[${PYTHON_USEDEP}]
		<dev-python/libbash-0.2[${PYTHON_USEDEP}]
		>=dev-python/pash-annotations-0.2.4[${PYTHON_USEDEP}]
		<dev-python/pash-annotations-0.3[${PYTHON_USEDEP}]
		>=dev-python/shasta-0.4[${PYTHON_USEDEP}]
		<dev-python/shasta-1[${PYTHON_USEDEP}]
		>=dev-python/sh-expand-0.2.0[${PYTHON_USEDEP}]
		<dev-python/sh-expand-0.3[${PYTHON_USEDEP}]
	')
	app-alternatives/awk
	app-shells/bash
	net-analyzer/openbsd-netcat
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/sed
	sys-process/procps
"
BDEPEND="test? ( ${RDEPEND} )"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-interpreter.patch"
)

src_prepare() {
	distutils-r1_src_prepare
	# The release still has an old CLI version in __init__.py.
	sed -i -e "s/^__version__ = .*/__version__ = \"${PV}\"/" \
		src/pash/__init__.py || die
	# The upstream ELF marker is data only; it does not need an executable stack.
	echo '.section .note.GNU-stack,"",@progbits' >> \
		"${WORKDIR}/dgsh-${DGSH_COMMIT}/core-tools/src/dgsh-elf.s" || die
}

src_compile() {
	emake -C src/pash/runtime CC="$(tc-getCC)" \
		DGSH_DIR="${WORKDIR}/dgsh-${DGSH_COMMIT}" \
		CPPFLAGS="${CPPFLAGS} -DNDEBUG" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	distutils-r1_src_compile
}

python_test() {
	local output
	output=$("${EPYTHON}" -m pash.cli --version) || die "Version command failed"
	[[ ${output} == "pash ${PV}" ]] || die "Incorrect version: ${output}"
	output=$("${EPYTHON}" -m pash.cli -w 2 --assert_all_regions_parallelizable \
		-c 'seq 10000 | grep 2 | wc -l') || die "Parallel pipeline failed"
	[[ ${output//[[:space:]]/} == 3439 ]] || die "Incorrect parallel pipeline output: ${output}"
	output=$("${EPYTHON}" -m pash.cli --bash -c 'a=(hello world); echo "${a[1]}"') || die "Bash parser failed"
	[[ ${output} == world ]] || die "Incorrect Bash output: ${output}"
}

python_install_all() {
	distutils-r1_python_install_all
	# Compiler sources and the runtime Makefile are not needed after installation.
	find "${ED}" -type f \( -name '*.c' -o -name '*.h' -o -name Makefile \) -delete || die
}
