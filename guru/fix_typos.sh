#!/bin/sh
# -*- coding: utf-8 -*-
###############################################################################
# $Id$
#
#  Project:  GDAL
#  Purpose:  (Interactive) script to identify and fix typos
#  Author:   Even Rouault <even.rouault at spatialys.com>
#
###############################################################################
#  Copyright (c) 2016, Even Rouault <even.rouault at spatialys.com>
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included
#  in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
#  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.
###############################################################################

# We have made minor modifications to the GDAL script so it works for GMT
# Basically I edited the EXCLUDED_FILES listing to include files we do not want
# to spell-check (grids, PDFs, PS).  There are probably stuff in the settings of
# WORDS_WHITE_LIST that can be removed (I dont understand that part) and I had
# to create a blank typos_whitelist.txt to prevent the script from crashing.
# Run as
# gmt5-dev/sandbox/guru/fix_typos.sh <top dir of trunk or a branch>, e.g.
# cd ....../branches/5.3
# 
# Paul Wessel, Nov 8, 2016

if [ $# -ne 1 ]; then
	echo "usage: fix_typos.sh <topdir>"
	exit
fi

pversion=`python --version 2>&1 | awk '{printf "%s\n", substr($2,1,1)}'`
if [ ! "X${pversion}" = "X3" ]; then
	echo "fix_typos.sh requires Python 3"
	echo "Under macports, find a 3+ python version and select it:"
	echo "port select --list python"
	echo "sudo port select --set python python35"
	exit
fi
HERE=`pwd`
DIR=$1
cd $DIR

if ! test -d fix_typos; then
    # Get our fork of codespell that adds --words-white-list and full filename support for -S option
    mkdir fix_typos
    cd fix_typos
    git clone https://github.com/rouault/codespell
    cd codespell
    git checkout gdal_improvements
    cd ..
    # Aggregate base dictionary + QGIS one + Debian Lintian one
    curl https://raw.githubusercontent.com/qgis/QGIS/master/scripts/spelling.dat | sed "s/:/->/" | grep -v "colour->" | grep -v "colours->" > qgis.txt
    curl https://anonscm.debian.org/cgit/lintian/lintian.git/plain/data/spelling/corrections| grep "||" | grep -v "#" | sed "s/||/->/" > debian.txt
    cat codespell/data/dictionary.txt qgis.txt debian.txt | awk 'NF' > gmt_dict.txt
    echo "difered->deferred" >> gmt_dict.txt
    echo "differed->deferred" >> gmt_dict.txt
    cd ..
fi

EXCLUDED_FILES="*/.git*,configure,config.status,config.sub,*/autom4te.cache/*"
EXCLUDED_FILES="$EXCLUDED_FILES,*/doc/br/*,*/data/*,figures.mp,*/tmp/*,*/ruby/*,*.grd"
EXCLUDED_FILES="$EXCLUDED_FILES,*/localization/*,*.jpg,*.png,*.xyg,*.xym,tracks.txt,oz_quakes.txt,gshhs_c.txt,carter.d"
EXCLUDED_FILES="$EXCLUDED_FILES,*/dbuild/*,*/rbuild/*,*/dbuild-mp/*,*/rbuild-mp/*,*/xbuild/*"
EXCLUDED_FILES="$EXCLUDED_FILES,*/fix_typos/*,fix_typos.sh,*.eps,*.ps,*.pdf,europe-capitals-ru.csv"
EXCLUDED_FILES="$EXCLUDED_FILES,dbuild/*,rbuild/*,dbuild-mp/*,LICENCE.txt,*.CM4,*.nc,*.rot,*.segy"
WORDS_WHITE_LIST="CPL_SUPRESS_CPLUSPLUS,SRP_NAM,ADRG_NAM,'SRP_NAM,AuxilaryTarget"
# IRIS driver metadata item names: FIXME ?
WORDS_WHITE_LIST="$WORDS_WHITE_LIST,TOP_OF_HEIGTH_INTERVAL,BOTTOM_OF_HEIGTH_INTERVAL"
# libjpeg
WORDS_WHITE_LIST="$WORDS_WHITE_LIST,JBUF_PASS_THRU"
# libgif
WORDS_WHITE_LIST="$WORDS_WHITE_LIST,IS_WRITEABLE,E_GIF_ERR_NOT_WRITEABLE"
# libtiff
WORDS_WHITE_LIST="$WORDS_WHITE_LIST,THRESHHOLD_BILEVEL,THRESHHOLD_HALFTONE,THRESHHOLD_ERRORDIFFUSE"

if [ ! -f typos_whitelist.txt ]; then	# If no such file, make an empty one
	touch typos_whitelist.txt
fi

python fix_typos/codespell/codespell.py -w -i 3 -q 2 -S $EXCLUDED_FILES \
    -x typos_whitelist.txt --words-white-list=$WORDS_WHITE_LIST \
    -D fix_typos/gmt_dict.txt .
