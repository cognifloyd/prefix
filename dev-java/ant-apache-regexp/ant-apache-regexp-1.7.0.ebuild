# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-regexp/ant-apache-regexp-1.7.0.ebuild,v 1.10 2007/05/12 18:04:17 wltjr Exp $

EAPI="prefix"

ANT_TASK_DEPNAME="jakarta-regexp-1.4"

inherit ant-tasks

KEYWORDS="~amd64 ~ia64 ~ppc-macos ~x86 ~x86-fbsd ~x86-macos ~x86-solaris"

# could use slot deps
DEPEND="=dev-java/jakarta-regexp-1.4*"
RDEPEND="${DEPEND}"
