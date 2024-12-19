# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4-r1

EAPI=8

CRATES="
	ansi_term@0.11.0
	atty@0.2.14
	bitflags@1.3.2
	clap@2.33.3
	dbus@0.9.5
	heck@0.3.3
	hermit-abi@0.1.19
	lazy_static@1.4.0
	libc@0.2.103
	libdbus-sys@0.2.2
	pkg-config@0.3.20
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.30
	quote@1.0.10
	strsim@0.8.0
	structopt@0.3.23
	structopt-derive@0.4.16
	syn@1.0.80
	textwrap@0.11.0
	unicode-segmentation@1.8.0
	unicode-width@0.1.9
	unicode-xid@0.2.2
	vec_map@0.8.2
	version_check@0.9.3
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
"

inherit git-r3 cargo

DESCRIPTION="A reimplementation of xrandr for Gnome on Wayland"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/maxwellainatchi/gnome-randr-rust"
SRC_URI="${CARGO_CRATE_URIS}"
EGIT_REPO_URI="${HOMEPAGE}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
}