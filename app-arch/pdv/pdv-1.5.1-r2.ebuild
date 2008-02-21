# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pdv/pdv-1.5.1-r2.ebuild,v 1.6 2008/02/20 07:51:46 ulm Exp $

EAPI="prefix"

WANT_AUTOCONF=2.5
WANT_AUTOMAKE=1.4

inherit eutils autotools

DESCRIPTION="build a self-extracting and self-installing binary package"
HOMEPAGE="http://pdv.sourceforge.net/"
SRC_URI="mirror://sourceforge/pdv/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86-linux ~ppc-macos"
IUSE="X"

DEPEND="X? ( x11-libs/openmotif
	>=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libXext-1.0.0
	>=x11-libs/libXp-1.0.0 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix a size-of-variable bug
	epatch "${FILESDIR}"/${P}-opt.patch
	# fix a free-before-use bug
	epatch "${FILESDIR}"/${P}-early-free.patch
	# fix a configure script bug
	epatch "${FILESDIR}"/${P}-x-config.patch
	# fix default args bug from assuming 'char' is signed
	epatch "${FILESDIR}"/${P}-default-args.patch
}

src_compile() {
	# re-build configure script since patch was applied to configure.in
	cd "${S}"/X11
	eautoreconf

	cd "${S}"
	local myconf=""
	use X || myconf="--without-x" # configure script is broken, cant use use_with
	econf ${myconf} || die
	emake || die
}

src_install() {
	dobin pdv pdvmkpkg || die
	doman pdv.1 pdvmkpkg.1
	if use X ; then
		dobin X11/xmpdvmkpkg || die
		doman xmpdvmkpkg.1 || die
	fi
	dodoc AUTHORS ChangeLog NEWS README pdv.lsm
}
