# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/automake/automake-1.5-r1.ebuild,v 1.15 2014/01/17 04:23:15 vapier Exp $

inherit eutils prefix

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="http://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV:0:3}"
KEYWORDS="~ppc-aix ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-9
	>=sys-devel/autoconf-2.59-r6
	sys-devel/gnuconfig"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/automake-1.4-nls-nuisances.patch #121151
	epatch "${FILESDIR}"/${P}-target_hook.patch
	epatch "${FILESDIR}"/${P}-slot.patch

	# the slot patch hardcodes /usr/local/share/aclocal
	epatch "${FILESDIR}"/${P}-slot-prefix.patch
	eprefixify aclocal.in

	epatch "${FILESDIR}"/${P}-test-fixes.patch #79505
	epatch "${FILESDIR}"/${PN}-1.10-ccnoco-ldflags.patch #203914
	epatch "${FILESDIR}"/${P}-CVE-2009-4029.patch #295357
	export WANT_AUTOCONF=2.5
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	pushd "${ED}"/usr/share/info >/dev/null
	rm -f dir

	# Rewrite all the references to other pages.
	# before: * aclocal-invocation: (automake)aclocal Invocation.   Generating aclocal.m4.
	# after:  * aclocal-invocation v1.13: (automake-1.13)aclocal Invocation.   Generating aclocal.m4.
	local p pages=( *.info ) args=()
	for p in "${pages[@]/%.info}" ; do
		args+=(
			-e "/START-INFO-DIR-ENTRY/,/END-INFO-DIR-ENTRY/s|: (${p})| v${SLOT}&|"
			-e "s:(${p}):(${p}-${SLOT}):g"
		)
	done
	sed -i "${args[@]}" * || die

	# Rewrite all the file references, and rename them in the process.
	local f d
	for f in * ; do
		d=${f/.info/-${SLOT}.info}
		mv "${f}" "${d}" || die
		sed -i -e "s:${f}:${d}:g" * || die
	done

	popd >/dev/null
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	slot_info_pages

	local x=
	for x in aclocal automake ; do
		mv "${ED}"/usr/bin/${x}{,-${SLOT}} || die "rename ${x}"
		mv "${ED}"/usr/share/${x}{,-${SLOT}} || die "move ${x}"
	done

	dodoc NEWS README THANKS TODO AUTHORS ChangeLog

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
