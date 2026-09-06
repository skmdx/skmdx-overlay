# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic go-module

DESCRIPTION="Plain text note-taking assistant"
HOMEPAGE="https://zk-org.github.io/zk/ https://github.com/zk-org/zk"
SRC_URI="https://github.com/zk-org/zk/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# Files from upstream go.sum, including transitive module metadata and tests.
# Fetch modules individually because upstream does not publish a vendor tarball.
MY_GO_MODULE_FILES=(
	github.com/!alec!aivazis/survey/v2@v2.3.4.info
	github.com/!alec!aivazis/survey/v2@v2.3.4.mod
	github.com/!alec!aivazis/survey/v2@v2.3.4.zip
	github.com/!netflix/go-expect@v0.0.0-20220104043353-73e0943537d2.info
	github.com/!netflix/go-expect@v0.0.0-20220104043353-73e0943537d2.mod
	github.com/!netflix/go-expect@v0.0.0-20220104043353-73e0943537d2.zip
	github.com/alecthomas/kong@v0.5.0.info
	github.com/alecthomas/kong@v0.5.0.mod
	github.com/alecthomas/kong@v0.5.0.zip
	github.com/alecthomas/repr@v0.0.0-20210801044451-80ca428c5142.info
	github.com/alecthomas/repr@v0.0.0-20210801044451-80ca428c5142.mod
	github.com/alecthomas/repr@v0.0.0-20210801044451-80ca428c5142.zip
	github.com/aymerick/raymond@v2.0.2+incompatible.info
	github.com/aymerick/raymond@v2.0.2+incompatible.mod
	github.com/aymerick/raymond@v2.0.2+incompatible.zip
	github.com/bmatcuk/doublestar/v4@v4.0.2.info
	github.com/bmatcuk/doublestar/v4@v4.0.2.mod
	github.com/bmatcuk/doublestar/v4@v4.0.2.zip
	github.com/creack/pty@v1.1.17.mod
	github.com/creack/pty@v1.1.18.info
	github.com/creack/pty@v1.1.18.mod
	github.com/creack/pty@v1.1.18.zip
	github.com/creack/pty@v1.1.9.mod
	github.com/davecgh/go-spew@v1.1.0.mod
	github.com/davecgh/go-spew@v1.1.1.info
	github.com/davecgh/go-spew@v1.1.1.mod
	github.com/davecgh/go-spew@v1.1.1.zip
	github.com/fatih/color@v1.13.0.info
	github.com/fatih/color@v1.13.0.mod
	github.com/fatih/color@v1.13.0.zip
	github.com/google/go-cmp@v0.5.8.info
	github.com/google/go-cmp@v0.5.8.mod
	github.com/google/go-cmp@v0.5.8.zip
	github.com/gorilla/websocket@v1.4.1.mod
	github.com/gorilla/websocket@v1.5.0.info
	github.com/gorilla/websocket@v1.5.0.mod
	github.com/gorilla/websocket@v1.5.0.zip
	github.com/gosimple/slug@v1.12.0.info
	github.com/gosimple/slug@v1.12.0.mod
	github.com/gosimple/slug@v1.12.0.zip
	github.com/gosimple/unidecode@v1.0.1.info
	github.com/gosimple/unidecode@v1.0.1.mod
	github.com/gosimple/unidecode@v1.0.1.zip
	github.com/hinshun/vt10x@v0.0.0-20220119200601-820417d04eec.info
	github.com/hinshun/vt10x@v0.0.0-20220119200601-820417d04eec.mod
	github.com/hinshun/vt10x@v0.0.0-20220119200601-820417d04eec.zip
	github.com/k0kubun/go-ansi@v0.0.0-20180517002512-3bf9e2903213.mod
	github.com/kballard/go-shellquote@v0.0.0-20180428030007-95032a82bc51.info
	github.com/kballard/go-shellquote@v0.0.0-20180428030007-95032a82bc51.mod
	github.com/kballard/go-shellquote@v0.0.0-20180428030007-95032a82bc51.zip
	github.com/kr/pretty@v0.1.0.mod
	github.com/kr/pretty@v0.2.1.mod
	github.com/kr/pretty@v0.3.0.info
	github.com/kr/pretty@v0.3.0.mod
	github.com/kr/pretty@v0.3.0.zip
	github.com/kr/pty@v1.1.1.mod
	github.com/kr/text@v0.1.0.mod
	github.com/kr/text@v0.2.0.info
	github.com/kr/text@v0.2.0.mod
	github.com/kr/text@v0.2.0.zip
	github.com/lestrrat-go/envload@v0.0.0-20180220234015-a3eb8ddeffcc.info
	github.com/lestrrat-go/envload@v0.0.0-20180220234015-a3eb8ddeffcc.mod
	github.com/lestrrat-go/envload@v0.0.0-20180220234015-a3eb8ddeffcc.zip
	github.com/lestrrat-go/strftime@v1.1.1.info
	github.com/lestrrat-go/strftime@v1.1.1.mod
	github.com/lestrrat-go/strftime@v1.1.1.zip
	github.com/mattn/go-colorable@v0.1.12.info
	github.com/mattn/go-colorable@v0.1.12.mod
	github.com/mattn/go-colorable@v0.1.12.zip
	github.com/mattn/go-colorable@v0.1.2.mod
	github.com/mattn/go-colorable@v0.1.9.mod
	github.com/mattn/go-isatty@v0.0.12.mod
	github.com/mattn/go-isatty@v0.0.14.info
	github.com/mattn/go-isatty@v0.0.14.mod
	github.com/mattn/go-isatty@v0.0.14.zip
	github.com/mattn/go-isatty@v0.0.8.mod
	github.com/mattn/go-runewidth@v0.0.13.info
	github.com/mattn/go-runewidth@v0.0.13.mod
	github.com/mattn/go-runewidth@v0.0.13.zip
	github.com/mattn/go-sqlite3@v1.14.22.info
	github.com/mattn/go-sqlite3@v1.14.22.mod
	github.com/mattn/go-sqlite3@v1.14.22.zip
	github.com/mgutz/ansi@v0.0.0-20170206155736-9520e82c474b.mod
	github.com/mgutz/ansi@v0.0.0-20200706080929-d51e80ef957d.info
	github.com/mgutz/ansi@v0.0.0-20200706080929-d51e80ef957d.mod
	github.com/mgutz/ansi@v0.0.0-20200706080929-d51e80ef957d.zip
	github.com/mitchellh/colorstring@v0.0.0-20190213212951-d06e56a500db.info
	github.com/mitchellh/colorstring@v0.0.0-20190213212951-d06e56a500db.mod
	github.com/mitchellh/colorstring@v0.0.0-20190213212951-d06e56a500db.zip
	github.com/mvdan/xurls@v1.1.0.info
	github.com/mvdan/xurls@v1.1.0.mod
	github.com/mvdan/xurls@v1.1.0.zip
	github.com/pelletier/go-toml@v1.9.5.info
	github.com/pelletier/go-toml@v1.9.5.mod
	github.com/pelletier/go-toml@v1.9.5.zip
	github.com/petermattis/goid@v0.0.0-20180202154549-b0b1615b78e5.mod
	github.com/petermattis/goid@v0.0.0-20220526132513-07eaf5d0b9f4.info
	github.com/petermattis/goid@v0.0.0-20220526132513-07eaf5d0b9f4.mod
	github.com/petermattis/goid@v0.0.0-20220526132513-07eaf5d0b9f4.zip
	github.com/pkg/errors@v0.9.1.info
	github.com/pkg/errors@v0.9.1.mod
	github.com/pkg/errors@v0.9.1.zip
	github.com/pmezard/go-difflib@v1.0.0.info
	github.com/pmezard/go-difflib@v1.0.0.mod
	github.com/pmezard/go-difflib@v1.0.0.zip
	github.com/relvacode/iso8601@v1.1.0.info
	github.com/relvacode/iso8601@v1.1.0.mod
	github.com/relvacode/iso8601@v1.1.0.zip
	github.com/rivo/uniseg@v0.2.0.info
	github.com/rivo/uniseg@v0.2.0.mod
	github.com/rivo/uniseg@v0.2.0.zip
	github.com/rogpeppe/go-internal@v1.6.1.mod
	github.com/rogpeppe/go-internal@v1.9.0.info
	github.com/rogpeppe/go-internal@v1.9.0.mod
	github.com/rogpeppe/go-internal@v1.9.0.zip
	github.com/rvflash/elapsed@v0.2.0.info
	github.com/rvflash/elapsed@v0.2.0.mod
	github.com/rvflash/elapsed@v0.2.0.zip
	github.com/sasha-s/go-deadlock@v0.3.1.info
	github.com/sasha-s/go-deadlock@v0.3.1.mod
	github.com/sasha-s/go-deadlock@v0.3.1.zip
	github.com/schollz/progressbar/v3@v3.8.6.info
	github.com/schollz/progressbar/v3@v3.8.6.mod
	github.com/schollz/progressbar/v3@v3.8.6.zip
	github.com/sourcegraph/jsonrpc2@v0.1.0.info
	github.com/sourcegraph/jsonrpc2@v0.1.0.mod
	github.com/sourcegraph/jsonrpc2@v0.1.0.zip
	github.com/stretchr/objx@v0.1.0.mod
	github.com/stretchr/testify@v1.10.0.info
	github.com/stretchr/testify@v1.10.0.mod
	github.com/stretchr/testify@v1.10.0.zip
	github.com/stretchr/testify@v1.3.0.mod
	github.com/stretchr/testify@v1.4.0.mod
	github.com/stretchr/testify@v1.6.1.mod
	github.com/stretchr/testify@v1.7.0.mod
	github.com/tj/assert@v0.0.0-20190920132354-ee03d75cd160.info
	github.com/tj/assert@v0.0.0-20190920132354-ee03d75cd160.mod
	github.com/tj/assert@v0.0.0-20190920132354-ee03d75cd160.zip
	github.com/tj/go-naturaldate@v1.3.0.info
	github.com/tj/go-naturaldate@v1.3.0.mod
	github.com/tj/go-naturaldate@v1.3.0.zip
	github.com/tliron/glsp@v0.1.1.info
	github.com/tliron/glsp@v0.1.1.mod
	github.com/tliron/glsp@v0.1.1.zip
	github.com/tliron/go-kutil@v0.1.59.info
	github.com/tliron/go-kutil@v0.1.59.mod
	github.com/tliron/go-kutil@v0.1.59.zip
	github.com/yuin/goldmark-meta@v1.1.0.info
	github.com/yuin/goldmark-meta@v1.1.0.mod
	github.com/yuin/goldmark-meta@v1.1.0.zip
	github.com/yuin/goldmark@v1.8.1.info
	github.com/yuin/goldmark@v1.8.1.mod
	github.com/yuin/goldmark@v1.8.1.zip
	github.com/zchee/color/v2@v2.0.6.info
	github.com/zchee/color/v2@v2.0.6.mod
	github.com/zchee/color/v2@v2.0.6.zip
	github.com/zk-org/pretty@v0.2.4.info
	github.com/zk-org/pretty@v0.2.4.mod
	github.com/zk-org/pretty@v0.2.4.zip
	golang.org/x/crypto@v0.0.0-20220131195533-30dcbda58838.mod
	golang.org/x/crypto@v0.52.0.info
	golang.org/x/crypto@v0.52.0.mod
	golang.org/x/crypto@v0.52.0.zip
	golang.org/x/net@v0.0.0-20211112202133-69e39bad7dc2.mod
	golang.org/x/sync@v0.20.0.info
	golang.org/x/sync@v0.20.0.mod
	golang.org/x/sync@v0.20.0.zip
	golang.org/x/sys@v0.0.0-20190222072716-a9d3bda3a223.mod
	golang.org/x/sys@v0.0.0-20190614084037-d442b75600c5.mod
	golang.org/x/sys@v0.0.0-20200116001909-b77594299b42.mod
	golang.org/x/sys@v0.0.0-20200223170610-d5e6a3e2c0ae.mod
	golang.org/x/sys@v0.0.0-20201119102817-f84b799fce68.mod
	golang.org/x/sys@v0.0.0-20210423082822-04245dca01da.mod
	golang.org/x/sys@v0.0.0-20210615035016-665e8c7367d1.mod
	golang.org/x/sys@v0.0.0-20210630005230-0f9fa26af87c.mod
	golang.org/x/sys@v0.0.0-20210927094055-39ccf1dd6fa6.mod
	golang.org/x/sys@v0.0.0-20220128215802-99c3d69c2c27.mod
	golang.org/x/sys@v0.45.0.info
	golang.org/x/sys@v0.45.0.mod
	golang.org/x/sys@v0.45.0.zip
	golang.org/x/term@v0.0.0-20201126162022-7de9c90e9dd1.mod
	golang.org/x/term@v0.0.0-20210503060354-a79de5458b56.mod
	golang.org/x/term@v0.0.0-20210927222741-03fcf44c2211.mod
	golang.org/x/term@v0.43.0.info
	golang.org/x/term@v0.43.0.mod
	golang.org/x/term@v0.43.0.zip
	golang.org/x/text@v0.3.3.mod
	golang.org/x/text@v0.3.6.mod
	golang.org/x/text@v0.37.0.info
	golang.org/x/text@v0.37.0.mod
	golang.org/x/text@v0.37.0.zip
	golang.org/x/tools@v0.0.0-20180917221912-90fa682c2a6e.mod
	gopkg.in/check.v1@v0.0.0-20161208181325-20d25e280405.mod
	gopkg.in/check.v1@v1.0.0-20180628173108-788fd7840127.mod
	gopkg.in/check.v1@v1.0.0-20201130134442-10cb98267c6c.info
	gopkg.in/check.v1@v1.0.0-20201130134442-10cb98267c6c.mod
	gopkg.in/check.v1@v1.0.0-20201130134442-10cb98267c6c.zip
	gopkg.in/djherbis/times.v1@v1.3.0.info
	gopkg.in/djherbis/times.v1@v1.3.0.mod
	gopkg.in/djherbis/times.v1@v1.3.0.zip
	gopkg.in/errgo.v2@v2.1.0.mod
	gopkg.in/yaml.v2@v2.2.2.mod
	gopkg.in/yaml.v2@v2.4.0.info
	gopkg.in/yaml.v2@v2.4.0.mod
	gopkg.in/yaml.v2@v2.4.0.zip
	gopkg.in/yaml.v3@v3.0.0-20200313102051-9f266ea9e77c.mod
	gopkg.in/yaml.v3@v3.0.0-20210107192922-496545a6307b.mod
	gopkg.in/yaml.v3@v3.0.1.info
	gopkg.in/yaml.v3@v3.0.1.mod
	gopkg.in/yaml.v3@v3.0.1.zip
)
for module in "${MY_GO_MODULE_FILES[@]}"; do
	SRC_URI+=" https://proxy.golang.org/${module%@*}/@v/${module#*@} -> ${module//\//_}"
done
unset module

LICENSE="GPL-3"
# Statically linked Go dependencies.
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="fzf"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}
	fzf? ( app-shells/fzf )
"
BDEPEND=">=dev-lang/go-1.25.0"

PATCHES=( "${FILESDIR}/${P}-test-home.patch" )

src_unpack() {
	unpack "${P}.tar.gz"

	local module cache_dir
	for module in "${MY_GO_MODULE_FILES[@]}"; do
		cache_dir="${T}/go-proxy/${module%@*}/@v"
		mkdir -p "${cache_dir}" || die
		cp "${DISTDIR}/${module//\//_}" "${cache_dir}/${module#*@}" || die
	done

	# Let Go populate its cache and ziphash files from the local proxy.
	# Portage verifies every distfile; Go also checks modules against go.sum.
	export GOPROXY="file://${T}/go-proxy" GOSUMDB=off GOTOOLCHAIN=local
	cd "${S}" || die
	ego mod download
	ego mod verify
}

src_configure() {
	# cgo disables LTO in its C probes; this C++-only flag conflicts with that.
	filter-flags -fwhole-program-vtables
	export CGO_ENABLED=1
	go-module_src_configure
}

src_compile() {
	# Use Gentoo's SQLite, which enables FTS5, instead of the bundled amalgamation.
	ego build -mod=readonly -trimpath -tags "libsqlite3 fts5" \
		-ldflags "-X=main.Version=v${PV}" -o zk .
}

src_test() {
	ego test -mod=readonly -tags "libsqlite3 fts5" ./...
}

src_install() {
	dobin zk
	einstalldocs
}
