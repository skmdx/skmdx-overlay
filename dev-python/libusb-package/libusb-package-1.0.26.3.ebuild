# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Packaged libusb shared libraries for Python."
HOMEPAGE="https://github.com/pyocd/libusb-package/"
SRC_URI="
	https://github.com/pyocd/libusb-package/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
BDEPEND="dev-python/tomli"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

python_prepare_all() {
	sed -i "s/import importlib_resources/import importlib.resources/g" "${S}/src/libusb_package/__init__.py" || die
	distutils-r1_python_prepare_all
}

