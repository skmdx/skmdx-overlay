# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DVBV5_HASH="9433fb06320875c86a4a376421c3d9f1fbbc31b5"
DVBV5_SYS_HASH="7cab8db03d2c278f79713cdd414a3a536093ac91"
CRYPTO_HASH="0c321a9dba726d9bfe9c9829cca1b5b59ae83381"

declare -A GIT_CRATES=(
	[dvbv5]="https://gitlab.com/kazuki08241/rust-libdvbv5;make-fd-ptr-public;${DVBV5_HASH}"
	[dvbv5-sys]="https://gitlab.com/kazuki08241/rust-libdvbv5-sys;${DVBV5_SYS_HASH};${DVBV5_SYS_HASH}"
	[cryptography-00]="https://github.com/kazuki0824/cryptographies-reference;${CRYPTO_HASH}"
	[cryptography-40]="https://github.com/kazuki0824/cryptographies-reference;${CRYPTO_HASH}"
)

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	ar@0.9.0
	async-channel@1.9.0
	async-io@1.13.0
	async-lock@2.8.0
	autocfg@1.4.0
	bindgen@0.71.1
	bitflags@1.3.2
	bitflags@2.9.0
	block-buffer@0.10.4
	bumpalo@3.17.0
	cargo-deb@2.11.2
	cargo_toml@0.21.0
	cbc-mac@0.1.1
	cc@1.2.21
	cexpr@0.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.40
	cipher@0.4.4
	clang-sys@1.8.1
	clap-num@1.2.0
	clap@4.5.31
	clap_builder@4.5.31
	clap_derive@4.5.28
	clap_lex@0.7.4
	cmake@0.1.54
	colorchoice@1.0.3
	colored@3.0.0
	concurrent-queue@2.5.0
	console@0.15.11
	core-foundation-sys@0.8.7
	cpp_utils@0.3.0
	crc32fast@1.4.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	ctrlc@3.4.5
	digest@0.10.7
	either@1.14.0
	elf@0.7.4
	encode_unicode@1.0.0
	env_filter@0.1.3
	env_logger@0.11.6
	equivalent@1.0.2
	errno@0.3.10
	event-listener@2.5.3
	fastrand@1.9.0
	fastrand@2.3.0
	filetime@0.2.25
	flate2@1.1.0
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-lite@1.13.0
	futures-task@0.3.31
	futures-time@3.0.0
	futures-util@0.3.31
	generic-array@0.14.7
	getrandom@0.3.1
	glob@0.3.2
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	indexmap@2.7.1
	indicatif@0.17.11
	inout@0.1.4
	instant@0.1.13
	io-lifetimes@1.0.11
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.15
	jobserver@0.1.32
	js-sys@0.3.77
	libc@0.2.170
	libloading@0.8.6
	libredox@0.1.3
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.15
	lockfree-object-pool@0.1.6
	log@0.4.26
	lzma-sys@0.1.20
	memchr@2.7.4
	minimal-lexical@0.2.1
	miniz_oxide@0.8.5
	nix@0.29.0
	nom@7.1.3
	num-traits@0.2.19
	number_prefix@0.4.0
	once_cell@1.20.3
	parking@2.2.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	polling@2.8.0
	portable-atomic@1.11.0
	proc-macro2@1.0.94
	quick-error@2.0.1
	quote@1.0.39
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.10
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-hash@2.1.1
	rustix@0.37.28
	rustix@0.38.44
	rustversion@1.0.20
	ryu@1.0.20
	serde@1.0.218
	serde_derive@1.0.218
	serde_json@1.0.140
	serde_spanned@0.6.8
	shlex@1.3.0
	simd-adler32@0.3.7
	slab@0.4.9
	socket2@0.4.10
	strsim@0.11.1
	subtle@2.6.1
	syn@2.0.99
	tail_cbc@0.1.2
	tar@0.4.44
	tempfile@3.17.1
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	typenum@1.18.0
	unicode-ident@1.0.18
	unicode-width@0.2.0
	utf8parse@0.2.2
	version_check@0.9.5
	waker-fn@1.2.0
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-link@0.1.0
	windows-sys@0.48.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.7.3
	wit-bindgen-rt@0.33.0
	xz2@0.1.7
	zopfli@0.8.1
"

inherit cargo

DESCRIPTION="A simple command for ISDB-T / ISDB-S character device"
HOMEPAGE="https://github.com/kazuki0824/recisdb-rs"

SRC_URI="https://github.com/kazuki0824/recisdb-rs/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+dvb"

BDEPEND="
	virtual/pkgconfig
	dev-build/cmake
"

RDEPEND="
	sys-apps/pcsc-lite
	media-libs/libv4l[dvb]
	media-libs/libaribb25
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/recisdb"
RUST_MIN_VER="1.80"

S="${WORKDIR}/recisdb-rs-${PV}"

src_prepare() {
	default

	ln -s "${WORKDIR}/cryptographies-reference-${CRYPTO_HASH}/block00" "${WORKDIR}/cryptography-00-${CRYPTO_HASH}"
	ln -s "${WORKDIR}/cryptographies-reference-${CRYPTO_HASH}/block40" "${WORKDIR}/cryptography-40-${CRYPTO_HASH}"
	ln -s "${WORKDIR}/rust-libdvbv5-make-fd-ptr-public" "${WORKDIR}/${DVBV5_HASH}"
	ln -s "${WORKDIR}/rust-libdvbv5-sys-${DVBV5_SYS_HASH}" "${WORKDIR}/${DVBV5_SYS_HASH}"

	sed -i \
		-e "/cryptography-00/ s|git = \"[^\"]*\"|path = \"${WORKDIR}/cryptographies-reference-${CRYPTO_HASH}/block00\"|" \
		-e "/cryptography-40/ s|git = \"[^\"]*\"|path = \"${WORKDIR}/cryptographies-reference-${CRYPTO_HASH}/block40\"|" \
		"${S}/b25-sys/Cargo.toml" || die

	sed -i \
		-e "s|dvbv5 = { git = .*|dvbv5 = { path = \"${WORKDIR}/rust-libdvbv5-make-fd-ptr-public\" }|" \
		-e "s|dvbv5-sys = { git = .*|dvbv5-sys = { path = \"${WORKDIR}/rust-libdvbv5-sys-${DVBV5_SYS_HASH}\" }|" \
		"${S}/Cargo.toml" || die

	sed -i 's/colored = "[^"]*"/colored = "^3.0.0"/' "${S}/recisdb-rs/Cargo.toml" || die

	rm "${S}/Cargo.lock" || die
}

src_configure() {
	export LIBARIBB25_DYNAMIC=1

	local myfeatures=(
		bg-runtime
		$(usev dvb)
	)

	local features_str="${myfeatures[*]}"
	features_str="${features_str// /,}"

	cargo_src_configure \
		-p recisdb \
		--no-default-features \
		--features "${features_str}"
}

src_install() {
	dobin target/release/recisdb
	dodoc README.md
}
