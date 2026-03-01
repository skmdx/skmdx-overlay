EAPI=8

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"

SRC_URI="
	amd64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64.zip -> ${P}-amd64.zip )
	arm64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-aarch64.zip -> ${P}-arm64.zip )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="app-arch/unzip"
RDEPEND="!dev-lang/bun"

RESTRICT="strip"
QA_PREBUILT="usr/bin/bun"

src_unpack() {
	default
	if use amd64; then
		mv bun-linux-x64 bun || die
	elif use arm64; then
		mv bun-linux-aarch64 bun || die
	fi
}

src_install() {
	dobin bun/bun
	dosym bun /usr/bin/bunx
}
