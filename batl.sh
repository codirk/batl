#!/bin/bash
#
# Copyright 2012 Markus Pielmeier
#
# This file is part of batl.
#
# batl utils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# batl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with batl.  If not, see <http://www.gnu.org/licenses/>.
#

set -e

fail() {
    echo "$1" >&2
    exit 1
}

LINE_PATTERN='^\(.*\)\([$]{\(.*\)}\)\(.*\)$'

while read line
do
    while [ -n "$line" ]
    do
	match=`echo "$line" | sed -e "s/$LINE_PATTERN/\2/"`
	cmd=`echo "$line" | sed -e "s/$LINE_PATTERN/\3/"`

	if [ "$match" != "\${$cmd}" ]
	then
	    break
	fi

	prefix=`echo "$line" | sed -e "s/$LINE_PATTERN/\1/"`
	line=`echo "$line" | sed -e "s/$LINE_PATTERN/\4/"`

	echo -n "$prefix"
	$cmd
    done

    echo "$line"
done
