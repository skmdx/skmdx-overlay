# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

MY_P="${PN}-3.43-4549"

DESCRIPTION="The MPEG Transport Stream Toolkit"
HOMEPAGE="https://tsduck.io/ https://github.com/tsduck/tsduck"
SRC_URI="https://github.com/tsduck/tsduck/archive/refs/tags/v3.43-4549.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="curl doc java libedit smartcard python rist srt ssl zlib"

DEPEND="
	curl? ( net-misc/curl )
	libedit? ( dev-libs/libedit )
	smartcard? ( sys-apps/pcsc-lite )
	rist? ( media-libs/librist )
	srt? ( media-libs/libsrt )
	ssl? ( dev-libs/openssl:= )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}
	java? ( virtual/jre )
	python? ( dev-lang/python )
"
BDEPEND="
	doc? ( app-text/asciidoctor )
	java? ( virtual/jdk )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	# Ensure we use the correct compiler
	tc-export CXX CC AR

	# Remove -Werror to avoid build failures due to warnings
	sed -i 's/-Werror//' Makefile.inc || die
}

src_compile() {
	# TSDuck requires C++20
	append-cxxflags -std=c++20 -Wno-error

	local myconf=(
		NOGITHUB=1
		NODEKTEC=1 # Requires proprietary SDK download
		NOVATEK=1  # Requires SDK download
		SYSPREFIX="${EPREFIX}/usr"
		$(usex curl '' 'NOCURL=1')
		$(usex libedit '' 'NOEDITLINE=1')
		$(usex smartcard '' 'NOPCSC=1')
		$(usex rist '' 'NORIST=1')
		$(usex srt '' 'NOSRT=1')
		$(usex ssl '' 'NOOPENSSL=1')
		$(usex zlib '' 'NOZLIB=1')
		$(usex java '' 'NOJAVA=1')
		$(usex python '' 'NOPYTHON=1')
		CXXFLAGS_EXTRA="${CXXFLAGS}"
		LDFLAGS_EXTRA="${LDFLAGS}"
	)

	tc-is-clang && myconf+=( LLVM=1 )

	# Build binaries
	emake "${myconf[@]}" default

	# Build documentation if requested
	use doc && emake "${myconf[@]}" docs-html
}

src_install() {
	local myconf=(
		NOGITHUB=1
		NODEKTEC=1
		NOVATEK=1
		SYSPREFIX="${EPREFIX}/usr"
		SYSROOT="${D}"
		$(usex curl '' 'NOCURL=1')
		$(usex libedit '' 'NOEDITLINE=1')
		$(usex smartcard '' 'NOPCSC=1')
		$(usex rist '' 'NORIST=1')
		$(usex srt '' 'NOSRT=1')
		$(usex ssl '' 'NOOPENSSL=1')
		$(usex zlib '' 'NOZLIB=1')
		$(usex java '' 'NOJAVA=1')
		$(usex python '' 'NOPYTHON=1')
		$(usex doc '' 'NODOC=1')
	)

	tc-is-clang && myconf+=( LLVM=1 )

	emake "${myconf[@]}" install
}
