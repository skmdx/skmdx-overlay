# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A tool to automatically scan for available Japanese TV channels (ISDB-T/ISDB-S) and output the scan results in various formats"
HOMEPAGE="https://github.com/tsukumijima/ISDBScanner"
SRC_URI="
	https://github.com/tsukumijima/ISDBScanner/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
RDEPEND="
	media-tv/recisdb
	dev-python/typer
	dev-python/ariblib
	dev-python/pydantic
	dev-python/ruamel-yaml
	dev-python/libusb-package
	dev-python/pyusb
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	sed -i "1i#! /usr/bin/env python" "${S}/isdb_scanner/__main__.py" || die
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	python_newscript "${S}/isdb_scanner/__main__.py" "isdb-scanner"
}

