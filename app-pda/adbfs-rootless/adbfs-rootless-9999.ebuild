# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Mount Android phones on Linux with adb"
HOMEPAGE="https://github.com/spion/adbfs-rootless"
EGIT_REPO_URI="https://github.com/spion/adbfs-rootless.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="sys-fs/fuse:0"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake \
		CXXFLAGS="${CXXFLAGS} -Wall $(pkg-config fuse --cflags)" \
		LDFLAGS="${LDFLAGS} -Wall $(pkg-config fuse --libs)"
}
