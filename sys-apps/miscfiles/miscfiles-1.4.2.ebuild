# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/miscfiles/miscfiles-1.4.2.ebuild,v 1.5 2007/01/22 17:49:54 vapier Exp $

EAPI="prefix"

inherit eutils

DESCRIPTION="Miscellaneous files"
HOMEPAGE="http://www.gnu.org/directory/miscfiles.html"
SRC_URI="mirror://gnu/miscfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~ia64-linux ~mips-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="minimal"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/miscfiles-1.3-Makefile.diff
}

src_install() {
	emake install prefix="${ED}/usr" || die
	dodoc GNU* NEWS ORIGIN README dict-README
	rm -f "${ED}"/usr/share/dict/README

	if use minimal ; then
		cd "${ED}"/usr/share/dict
		rm -f words extra.words
		gzip -9 *
		ln -s web2.gz words
		ln -s web2a.gz extra.words
		ln -s connectives{.gz,}
		ln -s propernames{.gz,}
		cd ..
		rm -r misc rfc
	fi
}

pkg_postinst() {
	if [[ ${EROOT} == "/" ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict /usr/share/dict/* > /dev/null
		eend $?
	fi
}
