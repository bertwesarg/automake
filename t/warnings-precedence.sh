#! /bin/sh
# Copyright (C) 2011-2012 Free Software Foundation, Inc.
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

# On the command line, in AM_INIT_AUTOMAKE, and in AUTOMAKE_OPTIONS,
# warnings specified later should take precedence over those specified
# earlier.

. ./defs || Exit 1

# We want (almost) complete control over automake options.
AUTOMAKE="$am_original_AUTOMAKE -Werror"

cat > Makefile.am <<'END'
.c.o .c.obj:
	@echo bad
AUTOMAKE_OPTIONS =
END

set_warnings ()
{
  set +x
  sed <$2 >$2-t -e "s|^\\(AUTOMAKE_OPTIONS\\) *=.*|\\1 = $1|" \
                -e "s|^\\(AM_INIT_AUTOMAKE\\).*|\\1([$1])|"
  mv -f $2-t $2
  set -x
  cat $2
}

ok ()
{
  $AUTOMAKE $*
}

ko ()
{
  AUTOMAKE_fails $*
  grep '^Makefile\.am:1:.*inference rules can have only one target' stderr
}

# Files required in gnu strictness.
touch README INSTALL NEWS AUTHORS ChangeLog COPYING

$ACLOCAL
ok -Wportability -Wno-portability
ko -Wno-portability -Wportability

set_warnings '' Makefile.am
set_warnings '-Wportability -Wno-portability' configure.ac
rm -rf autom4te*.cache
$ACLOCAL
ok
set_warnings '-Wno-portability -Wportability' configure.ac
rm -rf autom4te*.cache
$ACLOCAL
ko

set_warnings '' configure.ac
rm -rf autom4te*.cache
$ACLOCAL
set_warnings '-Wportability -Wno-portability' Makefile.am
ok
set_warnings '-Wno-portability -Wportability' Makefile.am
ko

: