#!/bin/sh
# Copyright (C) 2002-2012 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# We should support files with '$' characters in their names.
# Java people need this.
# PR/317, reported by Eric Siegerman and Philip Fong.

. ./defs || Exit 1

echo AC_OUTPUT >> configure.ac

cat > Makefile.am <<'EOF'
mydir = $(prefix)/my
dist_my_DATA = hello$$world

check-dist: distdir
	test -f '$(distdir)/hello$$world'
EOF

: > 'hello$world'

$ACLOCAL
$AUTOCONF
$AUTOMAKE
./configure --prefix "`pwd`/inst"
$MAKE install
test -f 'inst/my/hello$world'
$MAKE check-dist