# $Id$
#
# Copyright (c) 2012, Florian Wobbe
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

# libnetcdf sources in libsrc4
set (SRCS_NETCDF ${SRCS_NETCDF}
	#error.h
  nc4internal.h
	#netcdf.h
	#netcdf3.h
  error4.c
  nc4attr.c
  nc4dim.c
  nc4dispatch.c
  nc4file.c
  nc4grp.c
  nc4hdf.c
  nc4internal.c
  nc4type.c
  nc4var.c
  ncfunc.c
)

# vim: textwidth=78 noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
