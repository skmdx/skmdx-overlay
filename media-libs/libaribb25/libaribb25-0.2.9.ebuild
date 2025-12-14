# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="ARIB STD-B1 / ARIB STD-B25 library"
HOMEPAGE="https://github.com/tsukumijima/libaribb25"
SRC_URI="https://github.com/tsukumijima/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="static-libs cpu_flags_x86_avx2 cpu_flags_arm_neon"

REQUIRED_USE="|| (
	cpu_flags_x86_avx2
	cpu_flags_arm_neon
)"

RDEPEND="sys-apps/pcsc-lite[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_AVX2=$(usex cpu_flags_x86_avx2)
		-DUSE_NEON=$(usex cpu_flags_arm_neon)

		# Prevent the build system from running ldconfig directly.
		# The package manager will handle this.
		-DLDCONFIG_EXECUTABLE=/usr/bin/true
	)
	cmake-multilib_src_configure ${mycmakeargs[@]}
}

multilib_src_install() {
	cmake_src_install

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die "Failed to remove static libraries"
	fi
}
