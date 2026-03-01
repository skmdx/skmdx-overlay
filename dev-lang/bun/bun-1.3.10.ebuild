EAPI=8

# Bun requires LLVM 21 specifically.
LLVM_COMPAT=( 21 )

inherit cmake llvm-r1 go-module flag-o-matic

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, transpiler and package manager"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"

# Bun custom commit hashes from CMake configuration
ZIG_COMMIT="c031cbebf5b063210473ff5204a24ebfb2492c72"
WEBKIT_VERSION="4a6a32c32c11ffb9f5a94c310b10f50130bfe6de"
NODEJS_VERSION="24.3.0"

# Main source
SRC_URI="https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz -> ${P}.tar.gz"

# Bootstrap binary (to avoid dependency on bun-bin package during build)
SRC_URI+="
	amd64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-x64.zip -> bun-bootstrap-${PV}-amd64.zip )
	arm64? ( https://github.com/oven-sh/bun/releases/download/bun-v${PV}/bun-linux-aarch64.zip -> bun-bootstrap-${PV}-arm64.zip )
"

# Arch-specific prebuilt components
SRC_URI+="
	amd64? (
		https://github.com/oven-sh/zig/releases/download/autobuild-${ZIG_COMMIT}/bootstrap-x86_64-linux-musl.zip -> bun-zig-${ZIG_COMMIT}-amd64.zip
		https://github.com/oven-sh/WebKit/releases/download/autobuild-${WEBKIT_VERSION}/bun-webkit-linux-amd64.tar.gz -> bun-webkit-${WEBKIT_VERSION}-amd64.tar.gz
	)
	arm64? (
		https://github.com/oven-sh/zig/releases/download/autobuild-${ZIG_COMMIT}/bootstrap-aarch64-linux-musl.zip -> bun-zig-${ZIG_COMMIT}-arm64.zip
		https://github.com/oven-sh/WebKit/releases/download/autobuild-${WEBKIT_VERSION}/bun-webkit-linux-arm64.tar.gz -> bun-webkit-${WEBKIT_VERSION}-arm64.tar.gz
	)
"

# External dependencies (cloned during build normally)
declare -A DEPS=(
	[boringssl]="oven-sh/boringssl|4f4f5ef8ebc6e23cbf393428f0ab1b526773f7ac"
	[brotli]="google/brotli|v1.1.0"
	[picohttpparser]="h2o/picohttpparser|066d2b1e9ab820703db0837a7255d92d30f0c9f5"
	[cares]="c-ares/c-ares|3ac47ee46edd8ea40370222f91613fc16c434853"
	[hdrhistogram]="HdrHistogram/HdrHistogram_c|be60a9987ee48d0abf0d7b6a175bad8d6c1585d1"
	[highway]="google/highway|ac0d5d297b13ab1b89f48484fc7911082d76a93f"
	[libarchive]="libarchive/libarchive|9525f90ca4bd14c7b335e2f8c84a4607b0af6bdf"
	[libdeflate]="ebiggers/libdeflate|c8c56a20f8f621e6a966b716b31f1dedab6a41e3"
	[libuv]="libuv/libuv|f3ce527ea940d926c40878ba5de219640c362811"
	[lolhtml]="cloudflare/lol-html|e3aa54798602dd27250fafde1b5a66f080046252"
	[lshpack]="litespeedtech/ls-hpack|8905c024b6d052f083a3d11d0a169b3c2735c8a1"
	[mimalloc]="oven-sh/mimalloc|1beadf9651a7bfdec6b5367c380ecc3fe1c40d1a"
	[tinycc]="oven-sh/tinycc|12882eee073cfe5c7621bcfadf679e1372d4537b"
	[zlib]="cloudflare/zlib|886098f3f339617b4243b286f5ed364b9989e245"
	[zstd]="facebook/zstd|f8745da6ff1ad1e7bab384bd1f9d742439278e99"
)

for name in "${!DEPS[@]}"; do
	val="${DEPS[$name]}"
	repo="${val%|*}"
	ref="${val#*|}"
	if [[ $ref == v* ]]; then
		SRC_URI+=" https://github.com/${repo}/archive/refs/tags/${ref}.tar.gz -> bun-dep-${name}-${ref}.tar.gz"
	else
		SRC_URI+=" https://github.com/${repo}/archive/${ref}.tar.gz -> bun-dep-${name}-${ref}.tar.gz"
	fi
done

SRC_URI+=" https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-headers.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	$(llvm_gen_dep '
		llvm-core/llvm:${LLVM_SLOT}
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
	')
	dev-lang/go
	dev-lang/rust
	dev-lang/ruby
	app-arch/unzip
	dev-build/cmake
	dev-build/ninja
"
DEPEND=""
RDEPEND="!dev-lang/bun-bin"

S="${WORKDIR}/bun-bun-v${PV}"

src_unpack() {
	default
	
	mkdir -p "${S}/vendor" || die
	mkdir -p "${S}/build/cache" || die

	# Bootstrap binary setup
	if use amd64; then
		mv "${WORKDIR}/bun-linux-x64/bun" "${WORKDIR}/bun-bootstrap" || die
	elif use arm64; then
		mv "${WORKDIR}/bun-linux-aarch64/bun" "${WORKDIR}/bun-bootstrap" || die
	fi
	chmod +x "${WORKDIR}/bun-bootstrap" || die

	# Zig setup
	if use amd64; then
		mv bootstrap-x86_64-linux-musl "${S}/vendor/zig" || die
	elif use arm64; then
		mv bootstrap-aarch64-linux-musl "${S}/vendor/zig" || die
	fi

	# WebKit setup
	local webkit_prefix=$(echo ${WEBKIT_VERSION} | cut -c1-16)
	mv bun-webkit "${S}/build/cache/webkit-${webkit_prefix}" || die

	# External dependencies setup
	for name in "${!DEPS[@]}"; do
		val="${DEPS[$name]}"
		ref="${val#*|}"
		local dir_in_work
		
		# GitHub archive folder naming convention
		if [[ $ref == v* ]]; then
			# e.g. brotli-1.1.0
			dir_in_work="${name}-${ref#v}"
		else
			# e.g. boringssl-4f4f5ef8ebc6e23cbf393428f0ab1b526773f7ac
			# or for repos where name != last part of repo path, 
			# but DEPS keys are chosen to match GIT_NAME in CMake
			
			# Special cases for folder names in GitHub tarballs
			case $name in
				hdrhistogram) dir_in_work="HdrHistogram_c-${ref}" ;; 
				lshpack) dir_in_work="ls-hpack-${ref}" ;; 
				lolhtml) dir_in_work="lol-html-${ref}" ;; 
				cares) dir_in_work="c-ares-${ref}" ;; 
				boringssl) dir_in_work="boringssl-${ref}" ;; 
				mimalloc) dir_in_work="mimalloc-${ref}" ;; 
				picohttpparser) dir_in_work="picohttpparser-${ref}" ;; 
				highway) dir_in_work="highway-${ref}" ;; 
				libarchive) dir_in_work="libarchive-${ref}" ;; 
				libdeflate) dir_in_work="libdeflate-${ref}" ;; 
				libuv) dir_in_work="libuv-${ref}" ;; 
				tinycc) dir_in_work="tinycc-${ref}" ;; 
				zlib) dir_in_work="zlib-${ref}" ;; 
				zstd) dir_in_work="zstd-${ref}" ;; 
				*) dir_in_work="${name}-${ref}" ;; 
			esac

		fi
		
		einfo "Setting up vendor/${name} from ${dir_in_work}..."
		mv "${WORKDIR}/${dir_in_work}" "${S}/vendor/${name}" || die
		
		# Apply patches if any
		if [[ -d "${S}/patches/${name}" ]]; then
			einfo "Applying patches for ${name}..."
			while IFS= read -r patch_file; do
				if [[ ${patch_file} == *.patch ]]; then
					# Try -p1 then -p0
					(cd "${S}/vendor/${name}" && patch -p1 --ignore-whitespace --dry-run < "${patch_file}" >/dev/null 2>&1)
					if [[ $? -eq 0 ]]; then
						(cd "${S}/vendor/${name}" && patch -p1 --ignore-whitespace < "${patch_file}") || die "Failed to apply ${patch_file}"
					else
						(cd "${S}/vendor/${name}" && patch -p0 --ignore-whitespace < "${patch_file}") || die "Failed to apply ${patch_file}"
					fi
				else
					cp "${patch_file}" "${S}/vendor/${name}/" || die
				fi
			done < <(find "${S}/patches/${name}" -maxdepth 1 -type f)
		fi

		# Mark as cloned for Bun's CMake
		local git_ref="${ref}"
		[[ ${ref} == v* ]] && git_ref="refs/tags/${ref}"
		echo "${git_ref}" > "${S}/vendor/${name}/.ref" || die
	done

	# Node headers
	mkdir -p "${S}/vendor/nodejs" || die
	mv node-v${NODEJS_VERSION}/* "${S}/vendor/nodejs/" || die
	
	# Pre-prepare node headers
	rm -rf "${S}/vendor/nodejs/include/node/openssl" || die
	rm -rf "${S}/vendor/nodejs/include/node/uv" || die
	rm -f "${S}/vendor/nodejs/include/node/uv.h" || die
	touch "${S}/vendor/nodejs/include/.node-headers-prepared" || die
}

src_prepare() {
	# Patch Globals.cmake to skip register_repository and register_bun_install if outputs exist
	sed -i '/cmake_parse_arguments(GIT/a \ 	  if(NOT GIT_PATH)\n	    set(GIT_PATH ${VENDOR_PATH}/${GIT_NAME})\n	  endif()\n	  if(EXISTS "${GIT_PATH}/.ref")\n	    message(STATUS "Skipping repository ${GIT_NAME} (already exists)")\n	    if(NOT TARGET clone-${GIT_NAME})\n	      add_custom_target(clone-${GIT_NAME})\n	    endif()\n	    return()\n	  endif()' "${S}/cmake/Globals.cmake" || die
	
	sed -i '/cmake_parse_arguments(NPM/a \ 	  if(EXISTS "${NPM_CWD}/node_modules")\n	    message(STATUS "Skipping bun install in ${NPM_CWD} (already exists)")\n	    if(NOT TARGET install-${NPM_TARGET})\n	      add_custom_target(install-${NPM_TARGET})\n	    endif()\n	    return()\n	  endif()' "${S}/cmake/Globals.cmake" || die

	# Patch SetupZig.cmake to skip if ZIG_EXECUTABLE exists
	sed -i '/register_command(/i if(EXISTS "${ZIG_EXECUTABLE}")\n  if(NOT TARGET clone-zig)\n    add_custom_target(clone-zig)\n  endif()\n  return()\nendif()' "${S}/cmake/tools/SetupZig.cmake" || die

	# Replace -Werror with -Wno-error to prevent build failure on warnings
	# We replace instead of removing to avoid empty arguments in CMake functions
	find . -type f -name "*.cmake" -exec sed -i -E 's/-Werror(=[^ ]*)?/-Wno-error/g' {} + || die
	find . -type f -name "CMakeLists.txt" -exec sed -i -E 's/-Werror(=[^ ]*)?/-Wno-error/g' {} + || die

	# Forbid network access in CMake scripts
	sed -i '1i message(FATAL_ERROR "Network access is forbidden in this environment")' "${S}/cmake/scripts/DownloadUrl.cmake" || die
	sed -i '1i message(FATAL_ERROR "Network access is forbidden in this environment")' "${S}/cmake/scripts/DownloadZig.cmake" || die

	# The node-headers command in BuildBun.cmake is buggy (uses multiple COMMAND keywords
	# which register_command flattens incorrectly) and unnecessary since we provide 
	# the headers in src_unpack. Replace it with a no-op.
	sed -i '/"Download node ${NODEJS_VERSION} headers"/,/OUTPUTS/ { 
		/"Download node ${NODEJS_VERSION} headers"/! { 
			/OUTPUTS/!d 
		}
	}' "${S}/cmake/targets/BuildBun.cmake" || die
	sed -i '/"Download node ${NODEJS_VERSION} headers"/a \ 	  COMMAND ${CMAKE_COMMAND} -E echo "Skipping node headers download"' "${S}/cmake/targets/BuildBun.cmake" || die

	# Patch GenerateDependencyVersions.cmake to provide a fallback for BUN_GIT_SHA
	# when building outside of a git repository.
	sed -i 's/set(BUN_GIT_SHA "unknown")/set(BUN_GIT_SHA "'${PV}'")/' "${S}/cmake/tools/GenerateDependencyVersions.cmake" || die

	cmake_src_prepare
}

src_configure() {
	# We use the temporary bootstrap binary for codegen
	local webkit_prefix=$(echo ${WEBKIT_VERSION} | cut -c1-16)

	# Bun manages its own LTO and compiler flags. 
	# Gentoo's user-provided LTO flags can conflict with Bun's sub-project overrides (e.g. Brotli).
	filter-flags "-flto*" "-fwhole-program-vtables" "-Werror"
	append-flags "-Wno-error" "-DNDEBUG" "-DJSC_ASSERT_DISABLED=1" "-DASSERT_ENABLED=0"

	# Use the bootstrap binary downloaded via SRC_URI
	export BUN_EXECUTABLE="${WORKDIR}/bun-bootstrap"

	# Generate cmake/sources/*.txt files
	einfo "Generating source lists using ${BUN_EXECUTABLE}..."
	"${BUN_EXECUTABLE}" scripts/glob-sources.mjs || die "Failed to generate source lists"

	# Bun's CMake expects ABI to be gnu or musl
	local my_abi="gnu"
	if [[ ${CHOST} == *musl* ]]; then
		my_abi="musl"
	fi
	
	unset ABI

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_ASSERTIONS=OFF
		-DDEBUG=OFF
		-DWEBKIT_LOCAL=OFF
		-DSKIP_CODEGEN=OFF
		-DABI=${my_abi}
		-DBUN_EXECUTABLE="${BUN_EXECUTABLE}"
		-DZIG_PATH="${S}/vendor/zig"
		-DWEBKIT_PATH="${S}/build/cache/webkit-${webkit_prefix}"
		-DVENDOR_PATH="${S}/vendor"
		-DCACHE_PATH="${S}/build/cache"
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/bun"
	dosym bun /usr/bin/bunx
}
