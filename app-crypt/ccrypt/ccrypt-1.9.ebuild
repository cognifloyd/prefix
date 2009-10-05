# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ccrypt/ccrypt-1.9.ebuild,v 1.2 2009/10/03 09:41:39 maekke Exp $

DESCRIPTION="Encryption and decryption"
HOMEPAGE="http://ccrypt.sourceforge.net"
SRC_URI="http://ccrypt.sourceforge.net/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

src_install () {
	emake \
		DESTDIR="${D}" \
		htmldir="${EPREFIX}"/usr/share/doc/${PF} \
		install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
