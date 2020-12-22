# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailbase/mailbase-1.1.ebuild,v 1.1 2012/10/12 21:30:42 eras Exp $

inherit pam eutils user prefix

DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"

S=${WORKDIR}

pkg_setup() {
	enewgroup mail 12
	enewuser mail 8 -1 /var/spool/mail mail
	enewuser postmaster 14 -1 /var/spool/mail
}

src_install() {
	dodir /etc/mail
	insinto /etc/mail
	doins "${FILESDIR}"/aliases
	cp "${FILESDIR}"/mailcap .
	epatch "${FILESDIR}"/mailcap-prefix.patch
	eprefixify mailcap
	insinto /etc/
	doins mailcap

	keepdir /var/spool/mail
	fowners root:mail /var/spool/mail
	fperms 03775 /var/spool/mail
	dosym /var/spool/mail /var/mail

	newpamd "${FILESDIR}"/common-pamd-include pop
	newpamd "${FILESDIR}"/common-pamd-include imap
	if use pam ; then
		local p
		for p in pop3 pop3s pops ; do
			dosym pop /etc/pam.d/${p} || die
		done
		for p in imap4 imap4s imaps ; do
			dosym imap /etc/pam.d/${p} || die
		done
	fi
}

get_permissions_oct() {
	if [[ ${USERLAND} = GNU ]] ; then
		stat -c%a "${EROOT}$1"
	elif [[ ${USERLAND} = BSD ]] ; then
		stat -f%p "${EROOT}$1" | cut -c 3-
	fi
}

pkg_postinst() {
	if [[ "$(get_permissions_oct /var/spool/mail)" != "3775" ]] ; then
		echo
		ewarn "Your ${EROOT}/var/spool/mail/ directory permissions differ from"
		ewarn "  those which mailbase wants to set it to (03775)."
		ewarn "  If you did not change them on purpose, consider running:"
		ewarn
		ewarn "    chown root:mail ${EROOT}/var/spool/mail/"
		ewarn "    chmod 03775 ${EROOT}/var/spool/mail/"
		echo
	fi
}
