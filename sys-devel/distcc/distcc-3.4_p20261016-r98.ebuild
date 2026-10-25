# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
LLVM_COMPAT=( 22 23 )

inherit autotools flag-o-matic llvm-r2 prefix python-single-r1 systemd toolchain-funcs xdg

DESCRIPTION="Distributed C/C++ and Rust compilation with adaptive scheduling"
HOMEPAGE="https://github.com/skmdx/distcc"
DISTCC_COMMIT="d0f7c87b40ad084f1275271b392500aa588824b7"
SRC_URI="
	https://github.com/skmdx/distcc/archive/${DISTCC_COMMIT}.tar.gz -> ${PF}.tar.gz
	mirror://gnu/gcc/gcc-15.3.0/gcc-15.3.0.tar.xz
	mirror://gcc/snapshots/16-20260926/gcc-16-20260926.tar.xz
"
S="${WORKDIR}/${PN}-${DISTCC_COMMIT}"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE+=" gssapi gui hardened ipv6 selinux test xinetd zeroconf"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/lz4
	dev-libs/popt
	>=dev-libs/xxhash-0.8
	$(python_gen_cond_dep 'dev-python/xxhash[${PYTHON_USEDEP}]')
	net-misc/rsync
	net-misc/openssh
	sys-apps/util-linux
	sys-apps/bubblewrap
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	gssapi? ( net-libs/libgssglue )
	gui? ( x11-libs/gtk+:3 )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="
	${RDEPEND}
	sys-devel/gcc
	sys-libs/binutils-libs
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	dev-build/autoconf-archive
	virtual/pkgconfig
	test? ( sys-devel/gcc )
"
RDEPEND+="
	acct-user/distcc
	>=dev-util/shadowman-4
	>=sys-devel/gcc-config-1.4.1
	selinux? ( sec-policy/selinux-distcc )
	xinetd? ( sys-apps/xinetd )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0-xinetd.patch"
	# SOCKSv5 support needed for Portage, bug #537616
	"${FILESDIR}/${PN}-3.2_rc1-socks5.patch"
)

src_unpack() {
	unpack "${PF}.tar.gz"
	# Only private input-state definitions are needed. Keep extraction bounded;
	# xz otherwise chooses decoder memory from host RAM rather than the cgroup.
	local source
	for source in gcc-15.3.0 gcc-16-20260926; do
		XZ_OPT="--threads=1 --memlimit-decompress=256MiB" tar -xJf "${DISTDIR}/${source}.tar.xz" \
			"${source}"/gcc/{BASE-VER,DATESTAMP,intl.h} \
			"${source}"/libcpp/{files.cc,internal.h} \
			"${source}"/libcpp/include/{cpplib.h,mkdeps.h} || die
	done
}

src_prepare() {
	default

	# Bugs #120001, #167844 and probably more. See patch for description.
	use hardened && eapply "${FILESDIR}/distcc-hardened.patch"

	sed \
		-e "s:@EPREFIX@:${EPREFIX:-/}:" \
		"${FILESDIR}/distcc-config-r1" > "${T}/distcc-config" || die

	hprefixify update-distcc-symlinks.py src/{serve,daemon}.c
	python_fix_shebang distcc-link distcc-clang distcc-rust update-distcc-symlinks.py "${T}/distcc-config" \
		packaging/systemd/distccd-memory.py
	eautoreconf
}

src_configure() {
	llvm_chost_setup
	export LLVM_CONFIG="${T}/llvm-bin/${CHOST}-llvm-config"
	tc-export CC CXX
	if tc-is-cross-compiler; then
		local includedir
		includedir=$(python_get_includedir) || die
		append-cppflags "-I${includedir}"
		local configs=( "${ESYSROOT}/usr/lib/${EPYTHON}"/_sysconfigdata_*.py )
		[[ ${#configs[@]} -eq 1 && -f ${configs[0]} ]] ||
			die "Expected one target Python sysconfig module"
		mkdir -p "${T}/python-sysconfig" || die
		ln -s "${configs[0]}" "${T}/python-sysconfig/distcc_target_sysconfig.py" || die
	fi
	# https://github.com/distcc/distcc/issues/454
	append-cppflags -DPY_SSIZE_T_CLEAN

	local myconf=(
		--disable-Werror
		--libdir="${EPREFIX}"/usr/lib
		$(use_enable ipv6 rfc2553)
		$(use_with gui gtk)
		--without-gnome
		$(use_with gssapi auth)
		$(use_with zeroconf avahi)

		--enable-pump-mode
	)

	econf "${myconf[@]}"
}

distcc_emake() {
	local python_args=()
	if tc-is-cross-compiler; then
		# Keep the target configuration out of Portage's own Python helpers.
		python_args+=(
			"_PYTHON_SYSCONFIGDATA_NAME=distcc_target_sysconfig"
			"PYTHONPATH=${T}/python-sysconfig${PYTHONPATH:+:${PYTHONPATH}}"
		)
	fi
	emake "${python_args[@]}" "$@"
}

src_compile() {
	distcc_emake
	local headers target slot compiler version source count=0 module_cxx=${CXX}
	tc-is-cross-compiler && module_cxx+=" --sysroot=${ESYSROOT}"
	for headers in "${ESYSROOT}"/usr/lib/gcc/*/*/plugin/include; do
		[[ -f ${headers}/gcc-plugin.h ]] || continue
		target=${headers#"${ESYSROOT}"/usr/lib/gcc/}
		target=${target%%/*}
		slot=${headers%/plugin/include}
		slot=${slot##*/}
		compiler=${target}-gcc-${slot}
		version=$(${compiler} -dumpfullversion) || die
		case ${version} in
			15.3.0) source=gcc-15.3.0 ;;
			16.2.1) source=gcc-16-20260926 ;;
			*) ewarn "No GCC dependency module source for ${compiler} ${version}"; continue ;;
		esac
		"${PYTHON}" include_server/build_gcc_scan.py --gcc "${compiler}" \
			--source "${WORKDIR}/${source}" --plugin-headers "${headers}" \
			--cxx "${module_cxx}" --output "${T}/gcc-modules" || die
		(( count += 1 ))
	done
	[[ ${count} -gt 0 ]] || die "No supported GCC plugin headers in the target sysroot"
}

src_test() {
	# sandbox breaks some tests, and hangs some too
	# retest once #590084 is fixed
	local -x SANDBOX_ON=0
	emake -j1 check
}

src_install() {
	# override GZIP_BIN to stop it from compressing manpages
	distcc_emake -j1 DESTDIR="${D}" GZIP_BIN=false install
	python_optimize
	local module directory headers target slot version
	while IFS= read -r -d '' module; do
		directory=${module#"${T}/gcc-modules/"}
		exeinto "/usr/lib/distcc/gcc-scan/${directory%/*}"
		doexe "${module}"
	done < <(find "${T}/gcc-modules" -name distcc_gcc_scan.so -print0)
	# Register with each compiler's own plugin lookup; the worker does not
	# need to spawn version probes before every compilation.
	for headers in "${ESYSROOT}"/usr/lib/gcc/*/*/plugin/include; do
		[[ -f ${headers}/gcc-plugin.h ]] || continue
		directory=${headers#"${ESYSROOT}"}
		target=${directory#/usr/lib/gcc/}
		target=${target%%/*}
		slot=${directory%/plugin/include}
		slot=${slot##*/}
		version=$(${target}-gcc-${slot} -dumpfullversion) || die
		module=/usr/lib/distcc/gcc-scan/${target}/${version}/distcc_gcc_scan.so
		[[ -f ${ED}${module} ]] || continue
		dosym "${module}" "${directory%/include}/distcc_gcc_scan.so"
	done

	newinitd "${FILESDIR}/distccd.initd" distccd
	systemd_newunit "${FILESDIR}/distccd.service-1" distccd.service
	systemd_install_serviced "${FILESDIR}/distccd.service.conf"
	systemd_dounit packaging/systemd/distcc-broker@.{socket,service}
	exeinto /usr/lib/distcc
	doexe packaging/systemd/distccd-memory.py
	insinto /usr/share/distcc
	doins packaging/systemd/distccd-memory.conf
	newins packaging/gentoo/pump.bashrc portage-pump.bashrc
	newins packaging/gentoo/jobs.bashrc portage-jobs.bashrc

	cp "${FILESDIR}/distccd.confd" "${T}/distccd" || die
	if use zeroconf; then
		cat >> "${T}/distccd" <<-EOF || die

		# Enable zeroconf support in distccd
		DISTCCD_OPTS="\${DISTCCD_OPTS} --zeroconf"
		EOF

		sed -i '/ExecStart/ s|$| --zeroconf|' "${D}$(systemd_get_systemunitdir)"/distccd.service || die
	fi
	doconfd "${T}/distccd"

	newenvd - 02distcc <<-EOF || die
		# This file is managed by distcc-config; use it to change these settings.
		# DISTCC_LOG and DISTCC_DIR should not be set.
		DISTCC_VERBOSE="${DISTCC_VERBOSE:-0}"
		DISTCC_FALLBACK="${DISTCC_FALLBACK:-1}"
		DISTCC_SAVE_TEMPS="${DISTCC_SAVE_TEMPS:-0}"
		DISTCC_TCP_CORK="${DISTCC_TCP_CORK}"
		DISTCC_SSH="${DISTCC_SSH}"
		UNCACHED_ERR_FD="${UNCACHED_ERR_FD}"
		DISTCC_ENABLE_DISCREPANCY_EMAIL="${DISTCC_ENABLE_DISCREPANCY_EMAIL}"
		DCC_EMAILLOG_WHOM_TO_BLAME="${DCC_EMAILLOG_WHOM_TO_BLAME}"
	EOF

	keepdir /usr/lib/distcc

	dobin "${T}/distcc-config"

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "doc/example/xinetd" distcc
	fi

	insinto /usr/share/shadowman/tools
	newins - distcc <<<"${EPREFIX}/usr/lib/distcc"

	rm -r "${ED}/etc/default" || die
	rm "${ED}/etc/distcc/clients.allow" || die
	rm "${ED}/etc/distcc/commands.allow.sh" || die
}

pkg_preinst() {
	if use gui; then
		xdg_pkg_preinst
	fi
	# Compatibility symlink for Portage
	dosym . /usr/lib/distcc/bin
	if [[ -e ${EROOT}/usr/lib/distcc/bin && ! -L ${EROOT}/usr/lib/distcc/bin ]]; then
		rm -rf "${EROOT}"/usr/lib/distcc/bin || die
	fi
}

pkg_postinst() {
	# remove the old paths when switching from libXX to lib
	if [[ $(get_libdir) != lib && ${SYMLINK_LIB} != yes && \
			-d ${EROOT}/usr/$(get_libdir)/distcc ]]; then
		rm -r -f "${EROOT}/usr/$(get_libdir)/distcc" || die
	fi

	if [[ -z ${ROOT} ]]; then
		eselect compiler-shadow update distcc
	fi

	elog
	elog "Tips on using distcc with Gentoo can be found at"
	elog "https://wiki.gentoo.org/wiki/Distcc"
	elog
	elog "Run builds under pump to distribute preprocessing and standalone -E calls."
	elog "Pump reuses DISTCC_BROKER; without a broker use ,cpp,lzo host options."
	elog "Use ,tcp on broker hosts for prepared jobs and shared input caching."
	elog "Update all clients and workers together before enabling ,tcp."
	elog "Compiler versions and target ABI must match; pump transfers client system headers."
	elog
	elog "Adaptive scheduling: enable --stats on each distccd, then add"
	elog "stats=3633,speed=FACTOR to each TCP host in /etc/distcc/hosts."
	elog "CPU counts and live load are fetched automatically; speed is relative per-core throughput."
	elog "Workers limit compile and link admission using available memory and memory pressure."
	elog "DISTCC_JOB_MEMORY sets the estimated memory per job in MiB (default 1024)."
	elog "Broker clients preprocess before reserving workers and bound failed remote attempts."
	elog "Use distcc -j to obtain the discovered concurrency limit."
	elog
	elog "To use the distccmon programs with Gentoo you should use this command:"
	elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-text 5"

	if use gui; then
		elog "Or:"
		elog "# DISTCC_DIR=\"${DISTCC_DIR:-${BUILD_PREFIX}/.distcc}\" distccmon-gnome"
		elog
		xdg_pkg_postinst
	fi
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && -z ${ROOT} ]]; then
		eselect compiler-shadow remove distcc
	fi
}
