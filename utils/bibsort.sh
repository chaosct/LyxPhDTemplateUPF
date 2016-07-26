#! /bin/sh -
### ====================================================================
###  @UNIX-shell-file{
###     author          = "Nelson H. F. Beebe",
###     version         = "0.20",
###     date            = "13 November 2010",
###     time            = "14:25:36 MST",
###     filename        = "bibsort.sin",
###     copyright       = "Copyright (C) 2000--2010 Nelson H. F. Beebe",
###     address         = "University of Utah
###                        Department of Mathematics, 110 LCB
###                        155 S 1400 E RM 233
###                        Salt Lake City, UT 84112-0090
###                        USA",
###     telephone       = "+1 801 581 5254",
###     FAX             = "+1 801 581 4148",
###     checksum        = "18153 1399 5196 40616",
###     email           = "beebe@math.utah.edu, beebe@acm.org,
###                        beebe@computer.org (Internet)",
###     codetable       = "ISO/ASCII",
###     keywords        = "bibliography, BibTeX, sorting",
###     license         = "GNU General Public License version 2 (or later)",
###     supported       = "yes",
###     docstring       = "This file contains the bibsort utility, a
###                        program for sorting BibTeX data base files by
###                        their BibTeX citation label names, or by
###                        another order determined by command-line
###                        switches.
###
###                        Usage:
###                              bibsort [-?] [-author] [-byaddress ] \
###                                      [-byarticleno] [-bybibdate] \
###					 [-bycoden] [-byday] [-byisbn10] \
###                                      [-byisbn13] [-byissn] \
###                                      [-bylabel] [-bynumber] \
###                                      [-bypages] [-bypublisher] \
###                                      [-byseries] [-byseriesvolume] \
###                                      [-byvolume] [-byyear] \
###                                      [-copyright] [-help] \
###					 [-reverse] [-version] \
###                                      [optional sort(1) switches] \
###                                      [<infile or bibfile(s)] >outfile
###
###                        Complete documentation for these options can
###                        be found in the companion bibsort.man file
###                        containing the UNIX manual pages for bibsort.
###
###                        The checksum field above contains a CRC-16
###                        checksum as the first value, followed by the
###                        equivalent of the standard UNIX wc (word
###                        count) utility output of lines, words, and
###                        characters.  This is produced by Robert
###                        Solovay's checksum utility.",
###  }
########################################################################

IFS='
 	'

initialize_sort_order()
{
    BYADDRESS=0
    BYARTICLENO=0
    BYBIBDATE=0
    BYCODEN=0
    BYDAY=0
    BYISBN10=0
    BYISBN13=0
    BYISSN=0
    BYLABEL=0
    BYNUMBER=0
    BYPAGES=0
    BYPUBLISHER=0
    BYSERIES=0
    BYSERIESVOLUME=0
    BYVOLUME=0
    BYYEAR=0
}

## Assign default initial values
initialize_sort_order
BYLABEL=1
DOAUTHOR=0
DOCOPYRIGHT=0
DOHELP=0
DOVERSION=0
FILES=
GO=1
OLD_STYLE_SORT_KEYS=no
OTHERSORTFLAGS=
REVERSE=0
SORTFLAGS=

## Force support of old-style sort options on systems with more recent POSIX
## support (e.g., GNU/Linux MIPS Gentoo 1.4.16)
_POSIX2_VERSION=199209
export _POSIX2_VERSION

## Loop over the command-line arguments, collecting bibsort switches,
## sort(1) switches, and file names.
while [ $# -gt -0 ]
do
	## Reduce GNU/POSIX style --option to -option, and
	## fold to a common letter case:
	opt=`echo $1 | tr A-Z a-z | sed -e 's/^--/-/' `

	case $opt in
	-author | -autho | -auth | -aut | -au | -a )
		DOAUTHOR=1
		GO=0
		;;

	-byaddress | -byaddres | -byaddre | -byaddr | -byadd | -byad )
		initialize_sort_order
		BYADDRESS=1
		;;

	-byarticleno | -byarticlen | -byarticle | -byarticl | -byartic | \
	-byarti | -byart | -byar )
		initialize_sort_order
		BYARTICLENO=1
		;;

	-bybibdate | -bybibdat | -bybibda | -bybibd | -bybib | -bybi | -byb )
		initialize_sort_order
		BYBIBDATE=1
		;;

	-bycoden | -bycode | -bycod | -byco | -byc )
		initialize_sort_order
		BYCODEN=1
		;;

	-byday | -byda | -byd )
		initialize_sort_order
		BYDAY=1
		;;

	-byisbn-10 | -byisbn-1 | -byisbn- | \
	-byisbn10 | -byisbn1 | -byisbn | -byisb )
		initialize_sort_order
		BYISBN10=1
		;;

	-byisbn-13 | \
	-byisbn13 )
		initialize_sort_order
		BYISBN13=1
		;;

	-byissn | -byiss )
		initialize_sort_order
		BYISSN=1
		;;

	-bylabel | -bylabe | -bylab | -byla | -byl )
		initialize_sort_order
		BYLABEL=1
		;;

	-bynumber | -bynumbe | -bynumb | -bynum | -bynu | -byn )
		initialize_sort_order
		BYNUMBER=1
		;;

	-bypages | -bypage | -bypag | -bypa )
		initialize_sort_order
		BYPAGES=1
		;;

	-bypublisher | -bypublishe | -bypublish | -bypublis | -bypubli | \
	-bypubl | -bypub | -bypu )
		initialize_sort_order
		BYPUBLISHER=1
		;;

	-byseries | -byserie | -byseri | -byser | -byse | -bys )
		initialize_sort_order
		BYSERIES=1
		;;

	-byseriesvolume | -byseriesvolum | -byseriesvolu | -byseriesvol | \
	-byseriesvo | -byseriesv )
		initialize_sort_order
		BYSERIESVOLUME=1
		;;

	-byvolume | -byvolum | -byvolu | -byvol | -byvo | -byv )
		initialize_sort_order
		BYVOLUME=1
		;;

	-byyear | -byyea | -byye | -byy )
		initialize_sort_order
		BYYEAR=1
		;;

	-copyright | -copyrigh | -copyrig | -copyri | -copyr | -copy | -cop | \
	-co | -c)
		DOCOPYRIGHT=1
		GO=0
		;;

	-\?| -help | -hel | -he | -h )
		DOHELP=1
		GO=0
		;;

	-reverse | -revers | -rever | -reve | -rev | -re | -r )
		REVERSE=1
		;;

	-version | -versio | -versi | -vers | -ver | -ve | -v )
		DOVERSION=1
		GO=0
		;;

	-*)			# all other switches are passed to sort
		OTHERSORTFLAGS="$OTHERSORTFLAGS $1"
		;;

	*)			# everything else is assumed to be a filename
		FILES="$FILES $1"
		;;

	esac
	shift			# discard this switch
done

if test $DOAUTHOR -ne 0
then
	cat 1>&2 <<EOF
Author:
 	Nelson H. F. Beebe
 	University of Utah
 	Department of Mathematics, 110 LCB
 	155 S 1400 E RM 233
 	Salt Lake City, UT 84112-0090
 	USA
 	Email: beebe@math.utah.edu, beebe@acm.org, beebe@computer.org (Internet)
 	WWW URL: http://www.math.utah.edu/~beebe
 	Telephone: +1 801 581 5254
 	FAX: +1 801 581 4148
EOF
fi

if test $DOCOPYRIGHT -ne 0
then
	cat 1>&2 <<EOF
########################################################################
########################################################################
########################################################################
###                                                                  ###
###             bibsort: sort a BibTeX bibliography file             ###
###                                                                  ###
###           Copyright (C) 2000--2014 Nelson H. F. Beebe            ###
###                                                                  ###
### This program is covered by the GNU General Public License (GPL), ###
### version 2 or later, available as the file COPYING in the program ###
### source distribution, and on the Internet at                      ###
###                                                                  ###
###               ftp://ftp.gnu.org/gnu/GPL                          ###
###                                                                  ###
###               http://www.gnu.org/copyleft/gpl.html               ###
###                                                                  ###
### This program is free software; you can redistribute it and/or    ###
### modify it under the terms of the GNU General Public License as   ###
### published by the Free Software Foundation; either version 2 of   ###
### the License, or (at your option) any later version.              ###
###                                                                  ###
### This program is distributed in the hope that it will be useful,  ###
### but WITHOUT ANY WARRANTY; without even the implied warranty of   ###
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    ###
### GNU General Public License for more details.                     ###
###                                                                  ###
### You should have received a copy of the GNU General Public        ###
### License along with this program; if not, write to the Free       ###
### Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,   ###
### MA 02111-1307 USA                                                ###
########################################################################
########################################################################
########################################################################
EOF
fi

if test $DOHELP -ne 0
then
        cat 1>&2 <<EOF
Usage:
        bibsort [-?] [-author]
                [-byaddress | -byarticleno | -bybibdate | -bycoden |
                 -byday | -byisbn10 | -byisbn13 | -byissn | -bylabel |
                 -bynumber | -bypages | -bypublisher | -byseries |
                 -byseriesvolume | -byvolume | -byyear]
                [-copyright] [-help] [-reverse] [-version]
                [ optional sort(1) options ]
                [ <infile or BibTeXfile(s) ] >outfile
EOF
fi

if test $DOVERSION -ne 0
then
	echo 'bibsort version 0.21 [07-Mar-2014]' 1>&2
fi

if test $GO -eq 0
then
	exit 0
fi

if test $REVERSE -eq 0
then
	r=
else
	r=r
fi

## Because the user may have given the -r (reverse) option anywhere, we
## must delay the setting of SORTFLAGS until all of the command-line
## arguments have been seen.  We are now ready to set SORTFLAGS.
##
## From bibsort-0.15, SORTFLAGS is set for every sorting type, and the
## -r option is handled above, rather than begin passed on to sort(1).
##
## SORTFLAGS now always defines at least two fields.
##
## The first field is the group field (comment-header, preamble,
## strings, normal-entries, and cross-referenced-entries), and it is
## always sorted in ascending order.
##
## All remaining numeric fields, and the citation label field, may be
## given the r (reverse) sort attribute.
##
## However, other nonnumeric fields (currently only the journal for
## -bypages and -byvolume) are always sorted in ascending order.
## Perhaps in a future version, this choice may be put under user
## control, but for now, I cannot see a good reason to do so.
##
## It might be advisable in a future version to add an option to control
## whether or not the citation-label field gets sorted in reverse order.
## In practice, since it is the last field to be sorted, then, except
## for the case where no -byxxx sort option is given, the citation label
## will be of little significance to the final sort order, so for now,
## its sort order remains beyond user control.
##
## NB: The year field is always sorted as text, rather than as a number,
## because it can have a value like 19xx or 20xx.

if   test $BYADDRESS -ne 0
then
	## key = <part>
	##	<C-k><address>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYARTICLENO -ne 0
then
	## key = <part>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><number>
	##	<C-k><articleno>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1 -2  +2n$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1 -k2,2 -k3,3n$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYBIBDATE -ne 0
then
	## key = <part>
	##	<C-k><bibdate-as-YYYY-MM-DD-HH-MM-SS>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYCODEN -ne 0
then
	## key = <part>
	##	<C-k><coden>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYDAY -ne 0
then
	## key = <part>
	##	<C-k><year>
	##	<C-k><month>
	##	<C-k><day>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$r -2  +2n$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1 -k2,2$r -k3,3n$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYISBN10 -ne 0
then
	## key = <part>
	##	<C-k><isbn-10>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYISBN13 -ne 0
then
	## key = <part>
	##	<C-k><isbn-13>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif   test $BYISSN -ne 0
then
	## key = <part>
	##	<C-k><issn>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif test $BYNUMBER -ne 0
then
	## key = <part>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>		<-- IGNORED
	##	<C-k><number>		<-- SORTED TWICE (NUMERIC, THEN LEXICOGRAPHIC)
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1 -2  +2$r -3  +4n$r -5  +4$r -5 +5n$r -6  +6n$r -7  +7$r -8"
	else
		SORTFLAGS="-t  -k1,1 -k2,2 -k3,3$r -k5,5n$r -k5,5$r -k6,6n$r -k7,7n$r -k8,8$r"
	fi
elif test $BYPAGES -ne 0
then
	## key = <part>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1 -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1 -k2,2 -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif test $BYPUBLISHER -ne 0
then
	## key = <part>
	##	<C-k><publisher>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif test $BYSERIES -ne 0
then
	## key = <part>
	##	<C-k><series>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$ -2  +2$r -3  +3n$r -4  +4n$r -5  +5n$r -6  +6$r -7"
	else
		SORTFLAGS="-t -k1,1$r -k2,2$r -k3,3$r -k4,4n$r -k5,5n$r -k6,6n$r -k7,7$r"
	fi
elif test $BYSERIESVOLUME -ne 0
then
	## key = <part>
	##	<C-k><volume>
	##	<C-k><citation-label>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><number>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1n$r -2  +2$r -3  +3 -4  +4$r -5  +5n$r -6  +6n$r -7  +7n$r -8  +8n$r -9"
	else
		SORTFLAGS="-t -k1,1 -k2,2n$r -k3,3$r -k4,4$r -k5,5$r -k6,6n$r -k7,7n$r -k8,8n$r -k9,9n$r"
	fi
elif test $BYVOLUME -ne 0
then
	## key = <part>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><number>		<-- SORTED TWICE (NUMERIC, THEN LEXICOGRAPHIC)
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	##	<C-k><citation-label>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1 -2  +2$r -3  +3n$r -4  +4n$r -5  +4$r -5  +5n$r -6  +6n$r -7  +7$r -8"
	else
		SORTFLAGS="-t -k1,1 -k2,2 -k3,3$r -k4,4n$r -k5,5n$r -k5,5$r -k6,6n$r -k7,7n$r -k8,8$r"
	fi
elif test $BYYEAR -ne 0
then
	## key = <part>
	##	<C-k><year>
	##	<C-k><citation-label>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><number>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$r -2  +2$r -3  +3 -4  +4n$r -5  +5n$r -6  +6n$r -7  +7n$r -8  +8n$r -9"
	else
		SORTFLAGS="-t -k1,1 -k2,2$r -k3,3$r -k4,4 -k5,5n$r -k6,6n$r -k7,7n$r -k8,8n$r -k9,9n$r"
	fi
else				# -bylabel, or no -byxxx option given
	BYLABEL=1
	## key = <part>
	##	<C-k><citation-label>
	##	<C-k><journal>
	##	<C-k><year>
	##	<C-k><volume>
	##	<C-k><number>
	##	<C-k><start-pages>
	##	<C-k><end-pages>
	if test "$OLD_STYLE_SORT_KEYS" = "yes"
	then
		SORTFLAGS="-t  +0 -1  +1$r -2  +2 -3  +3$r -4  +4n$r -5  +5n$r -6  +6n$r -7  +7n$r -8"
	else
		SORTFLAGS="-t -k1,1 -k2,2$r -k3,3$r -k4,4$r -k5,5n$r -k6,6n$r -k7,7n$r -k8,8n$r"
	fi
fi

## We store the awk program as a (very large) string constant
PROGRAM='
BEGIN { initialize() }

/^[ \t]*@[ \t]*[Pp][Rr][Ee][Aa][Mm][Bb][Ll][Ee][ \t]*{/ {
	trim()
	squeeze()
        k = index($0,"{") + 1
        print Sort_Key FilePart_Preamble substr($0,k) Hidden_Newline
        print_braced_item()
        next
}

/^[ \t]*@[ \t]*[sS][tT][rR][iI][nN][gG][ \t]*{/ {
	trim()
	squeeze()
        k = index($0,"{") + 1
        m = index($0,"=")
        print Sort_Key FilePart_String substr($0,k,m-k) Hidden_Newline
        print_braced_item()
        next
}

/^[ \t]*@[ \t]*[Pp][Rr][Oo][Cc][Ee][Ee][Dd][Ii][Nn][Gg][Ss][ \t]*{/ {
	item = collect_braced_item()
        k = index(item,"{") + 1
        m = index(item,",")
	citation_label = substr(item,k,m-k)
	print_item(BYSERIESVOLUME ? \
	    FilePart_Normal_Entry : FilePart_Cross_Referenced, \
	    citation_label,item)
        next
}

/^[ \t]*@[ \t]*[Bb][Oo][Oo][Kk][ \t]*{/ {
	## Need to do lookahead to find booktitle to decide whether to
	## sort like @Proceedings or @Article.  A cross-referenced @Book
	## must contain a booktitle assignment, which means that it
	## must be moved to the @Proceedings section of the .bib file.
	item = collect_braced_item()
        k = index(item,"{") + 1
        m = index(item,",")
	citation_label = substr(item,k,m-k)

	if (match(item,/[Bb][Oo][Oo][Kk][Tt][Ii][Tt][Ll][Ee] *=/) && \
	    (!BYSERIESVOLUME))	# sort like @Proceedings
	    print_item(FilePart_Cross_Referenced,citation_label,item)
	else			# sort like @Article
	    print_item(FilePart_Normal_Entry,citation_label,item)

        next
}

## "@keyword{label,"
/^[ \t]*@[ \t]*[a-zA-Z0-9]*[ \t]*{/       {
	item = collect_braced_item()
        k = index(item,"{") + 1
        m = index(item,",")
	citation_label = substr(item,k,m-k)
	print_item(FilePart_Normal_Entry,citation_label,item)
        next
}

{				# all other line types match this
	trim()
	print
	last_line = $0
}

END {
	if (last_line != "^[ \t]*$")
	    print Hidden_Newline

	printf(Sort_Prefix)
}


function brace_count(s, k,n,t)
{
    ## NB: This implementation of brace_count() is new with bibsort
    ## version 0.13; see the README file in the bibsort distribution for
    ## a lengthy performance report.  The old algorithm is labeled bc-1
    ## there, and the new one, bc-2.  On the tests there, the new one was
    ## up to 25.6 times faster.

    n = 0
    t = s

    while ((k = index(t,"{")) > 0)
    {
	n++
	t = substr(t,k+1)
    }

    t = s

    while ((k = index(t,"}")) > 0)
    {
	n--
	t = substr(t,k+1)
    }

    return (n)
}


function collect_braced_item( count,item)
{
    ## Starting with the current contents of $0, collect lines until we
    ## reach a zero brace count. To guard against infinite loops in the
    ## event of unbalanced braces, we abruptly terminate processing if
    ## an at-sign is detected in column 1.  This function is used for
    ## those entry types that require fancy sort preprocessing.

    squeeze()
    trim()
    count = brace_count($0)
    item = $0 "\n"

    while (count != 0)
    {
        if (getline <= 0)
            break

	if (substr($0,1,1) == "@") # should use match($0,/^[ \t]+@/),
				   # but this is faster, and usually correct
	    error("New entry encountered before balanced braces found")

        trim()
        item = item $0 Visible_Newline
        count += brace_count($0)
    }

    return item
}


function error(message)
{		# print a message and terminate with failing exit code
    warning(message)
    exit(1)
}


function get_bibtimestamp(s,    n, parts,t)
{   ## convert "Wed Sep 3 17:06:29 MDT 2003" to "2003.09.03 17:06:29 MDT"
    ## to provide a string in odometer order suitable for sorting
    ## [borrowed on [13-Nov-2010] from bibsql-0.02/bibtosql.awk]

    if (s == "")
	t = ""
    else
    {
	n = split(s, parts, " ")	# "Wed Sep 3 17:06:29 MDT 2003"

	if (n == 6)
	    t = sprintf("%04d.%02d.%02d %s %s",
			0 + parts[6],
			get_month_number(parts[2]),
			0 + parts[3],
			parts[4],
			parts[5])
	else if (n == 5)		# "Wed Sep 3 17:06:29 2003"
	    t = sprintf("%04d.%02d.%02d %s %s",
			0 + parts[5],
			get_month_number(parts[2]),
			0 + parts[3],
			parts[4],
			"???")
	else
	    t = ""
    }

    return (t)
}


function get_month_number(s)
{
    ## [borrowed on [13-Nov-2010] from bibsql-0.02/bibtosql.awk]

    return (int(index("xxx jan feb mar apr may jun jul aug sep oct nov dec ",
		      (" " substr(tolower(s),1,3) " ")) / 4))
}

function initialize( sum)
{
    # Force BYxxx options to Boolean values (0 or 1)
    BYADDRESS		= ((0 + BYADDRESS) != 0)
    BYARTICLENO		= ((0 + BYARTICLENO) != 0)
    BYBIBDATE		= ((0 + BYBIBDATE) != 0)
    BYCODEN		= ((0 + BYCODEN) != 0)
    BYDAY		= ((0 + BYDAY) != 0)
    BYISBN10		= ((0 + BYISBN10) != 0)
    BYISBN13		= ((0 + BYISBN13) != 0)
    BYISSN		= ((0 + BYISSN) != 0)
    BYLABEL		= ((0 + BYLABEL) != 0)
    BYNUMBER		= ((0 + BYNUMBER) != 0)
    BYPAGES		= ((0 + BYPAGES) != 0)
    BYPUBLISHER		= ((0 + BYPUBLISHER) != 0)
    BYSERIES		= ((0 + BYSERIES) != 0)
    BYSERIESVOLUME	= ((0 + BYSERIESVOLUME) != 0)
    BYVOLUME		= ((0 + BYVOLUME) != 0)
    BYYEAR		= ((0 + BYYEAR) != 0)

    ## Make sure that there are no conflicting sort order options:
    sum = (BYADDRESS + BYARTICLENO + BYBIBDATE + BYCODEN + BYDAY + \
	   BYISBN10 + BYISBN13 + BYISSN + BYLABEL + BYNUMBER + BYPAGES + \
	   BYPUBLISHER + BYSERIES + BYSERIESVOLUME + BYVOLUME + BYYEAR)

    if (sum == 1)
	;
    else if (sum == 0)
	BYLABEL = 1
    else
	error("Either zero, or exactly one, of the -byxxx options may be specified")

    Warning_OK			= 1

    FilePart_Header		= "\001"
    FilePart_Preamble		= "\002"
    FilePart_String		= "\003"
    FilePart_Normal_Entry	= "\004"
    FilePart_Cross_Referenced	= "\177"
    Sort_Prefix			= "\005"
    Hidden_Newline		= "\006"
    Visible_Newline		= "\007"
    Unknown_Value		= "\377" 	# such entries sort last
    Sort_Field_Separator	= "\013"	# C-k character

    Sort_Key			= Sort_Prefix "%%SORTKEY:"
    print Sort_Key FilePart_Header Hidden_Newline

    Month_Number["jan"]		= 1
    Month_Number["feb"]		= 2
    Month_Number["mar"]		= 3
    Month_Number["apr"]		= 4
    Month_Number["may"]		= 5
    Month_Number["jun"]		= 6
    Month_Number["jul"]		= 7
    Month_Number["aug"]		= 8
    Month_Number["sep"]		= 9
    Month_Number["oct"]		= 10
    Month_Number["nov"]		= 11
    Month_Number["dec"]		= 12
}


function jyvna(item,citation_label,     key,n,parts)
{
    ## Return a sort key of the form
a    ## <journal><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>

    n = split(value(item,citation_label,"pages[ \t]*=[ \t]*"),parts,"--")

    return ( \
	value(item,citation_label,"journal[ \t]*=[ \t]*") Sort_Field_Separator \
	year_value(value(item,citation_label,"year[ \t]*=[ \t]*")) Sort_Field_Separator \
	numeric_value(value(item,citation_label,"volume[ \t]*=[ \t]*")) Sort_Field_Separator \
	value(item,citation_label,"number[ \t]*=[ \t]*") Sort_Field_Separator \
	numeric_value(value(item,citation_label,"articleno[ \t]*=[ \t]*")))
}


function jyvnpp_key(item,citation_label, n,parts)
{
    ## Return a sort key of the form
    ## <journal><SFS><year><SFS><volume><SFS><number><SFS><start-pages><SFS><end-pages>
    ## NB: The number field is NOT converted to a number from bibsort-0.17 onward.

    n = split(value(item,citation_label,"pages[ \t]*=[ \t]*"),parts,"--")

    return ( \
	value(item,citation_label,"journal[ \t]*=[ \t]*") Sort_Field_Separator \
	year_value(value(item,citation_label,"year[ \t]*=[ \t]*")) Sort_Field_Separator \
	numeric_value(value(item,citation_label,"volume[ \t]*=[ \t]*")) Sort_Field_Separator \
	value(item,citation_label,"number[ \t]*=[ \t]*") Sort_Field_Separator \
	numeric_value(parts[1]) Sort_Field_Separator  \
	numeric_value((n > 1) ? parts[2] : parts[1]) )
}


function jyvpp(item,citation_label, n,parts,val)
{
    ## Return a sort key of one of the forms
    ## <address><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <coden><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <isbn10><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <isbn13><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <issn><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <journal><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <publisher><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>
    ## <series><SFS><year><SFS><volume><SFS><start-pages><SFS><end-pages>

    if (BYADDRESS)
	key = "address"
    else if (BYBIBDATE)
	key = "bibdate"
    else if (BYCODEN)
	key = "CODEN"
    else if (BYISBN10)
	key = "ISBN"
    else if (BYISBN13)
	key = "ISBN-13"
    else if (BYISSN)
	key = "ISSN"
    else if (BYPUBLISHER)
	key = "publisher"
    else if (BYSERIES)
	key = "series"
    else
	key = "journal"

    val = BYBIBDATE \
	? get_bibtimestamp(value(item,citation_label,(key "[ \t]*=[ \t]*"))) \
	: val = value(item,citation_label,(key "[ \t]*=[ \t]*"))

    n = split(value(item,citation_label,"pages[ \t]*=[ \t]*"),parts,"--")

    return ( \
	val Sort_Field_Separator \
	year_value(value(item,citation_label,"year[ \t]*=[ \t]*")) Sort_Field_Separator \
	numeric_value(value(item,citation_label,"volume[ \t]*=[ \t]*")) Sort_Field_Separator \
	numeric_value(parts[1]) Sort_Field_Separator  \
	numeric_value((n > 1) ? parts[2] : parts[1]) )
}


function numeric_value(s,    n, offset, t)
{
    ## Convert a string to a numeric value, substituting "infinity" (a
    ## large integer) for strings that begin with a nondigit, so that
    ## sort keys for unknown values will sort higher than any realistic
    ## value.  Subsequent nondigits in values are ignored, so that 20S
    ## will reduce to 20: such values are occasionally seen for volume,
    ## number, and pages values.

    ## This function was completely rewritten, and substantially
    ## enlarged, at bibsort version 0.21 in order to sort roman
    ## numbers before arabic numbers, and to sort alphanumeric page
    ## numbers (Annn, A-nnn, etc.)

    offset = 10000000	# roman numbers in [1, offset - 1], arabic numbers in [offset, Infinity]

    t = tolower(s)

    if (t ~ "^[ivxlcdm]+(-+[ivxlcdm]+)?$")	# roman numeral in page range or volume number
    {
	if (t ~ "^[ivxlcdm]+$")
	    t = roman_to_integer(t)
	else if (t ~ "^[ivxlcdm]+-+[ivxlcdm]+$")
	{
	    sub("-.*$", "", t)
	    t = roman_to_integer(t)
	}
	else
	{
	    warning("numeric_value(): cannot parse roman numerals in s = [" s "]")
	    t = 2147483647		# 2^31 - 1 = largest 32-bit twos complement integer
	}
    }
    else
    {
	if (s ~ /^[A-Z][0-9]/)	# SIAM-style Ammm--Annn, Bmmm--Bmmm, etc.
	{
	    n = index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", substr(s, 1, 1))
	    t = offset + n * 10000000 + substr(s, 2)
	}
	else if (s ~ /^[A-Z]-[0-9]/) # sectional-style A-mmm--A-nnn, B-mmm--B-mmm, etc.
	{
	    n = index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", substr(s, 1, 1))
	    t = offset + n * 10000000 + substr(s, 3)
	}
	else if (s ~ /^[0-9]/)
	    t = offset + s
	else	# non-numeric values sort AFTER numeric ones
	    t = 2147483647		# 2^31 - 1 = largest 32-bit twos complement integer
    }

    return (0 + t)
}


function page_range_key(item,citation_label, n,parts)
{
    ## Return a sort key of the form
    ## <start-pages><SFS><end-pages>

    n = split(value(item,citation_label,"pages[ \t]*=[ \t]*"),parts,"--")

    return ( numeric_value(parts[1]) Sort_Field_Separator  \
	     numeric_value((n > 1) ? parts[2] : parts[1]) )
}


function print_braced_item(count)
{
    ## Starting with the current contents of $0, print lines until we
    ## reach a zero brace count.  This function is used for
    ## @Preamble{...} and @String{...}, which require no special
    ## processing.

    count = brace_count($0)
    print $0

    while (count != 0)
    {
        if (getline <= 0)
            break

        printf("%s%s",$0,Visible_Newline)
        count += brace_count($0)
    }
}


function print_item(filepart,citation_label,item, complete_sort_key,primary_key,other_key,v)
{
    if (citation_label in Cross_Referenced_Item) # change filepart if this item
	filepart = FilePart_Cross_Referenced # was cross-referenced earlier

    if (BYARTICLENO)
    {
	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator jyvna(item,citation_label) \
	    Sort_Field_Separator citation_label
    }
    else if (BYDAY)
    {
	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator ymd_key(item,citation_label) \
	    Sort_Field_Separator page_range_key(item,citation_label) \
	    Sort_Field_Separator citation_label
    }
    else if (BYADDRESS || BYBIBDATE || BYCODEN || BYISBN10 || BYISBN13 || BYISSN || BYPAGES || BYPUBLISHER || BYSERIES)
    {
	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator jyvpp(item,citation_label) \
	    Sort_Field_Separator citation_label
    }
    else if (BYSERIESVOLUME)
    {
	primary_key = series_volume_key(item,citation_label)

	## Now add a volume key too, so that identical labels
	## in a periodical bibliography (e.g., from a regular column)
	## sort in publication order.  Warnings are suppressed, because
	## we may not have journal/year/volume/number data.
	Warning_OK = 0
	other_key = jyvnpp_key(item,citation_label)
	Warning_OK = 1

	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator primary_key \
	    Sort_Field_Separator citation_label \
	    Sort_Field_Separator other_key
    }
    else if (BYNUMBER || BYVOLUME)
    {
	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator jyvnpp_key(item,citation_label) \
	    Sort_Field_Separator citation_label
    }
    else if (BYYEAR)
    {
	primary_key = match(item,/:[12][0-9][0-9x][0-9x]:/) ? \
	    substr(item,RSTART+1,RLENGTH-2) : \
	    year_value(value(item,citation_label,"year[ \t]*=[ \t]*"))

	## Now add a volume key too, so that identical labels
	## in a periodical bibliography (e.g., from a regular column)
	## sort in publication order.  Warnings are suppressed, because
	## we may not have journal/year/volume/number data.
	Warning_OK = 0
	other_key = jyvnpp_key(item,citation_label)
	Warning_OK = 1

	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator primary_key \
	    Sort_Field_Separator citation_label \
	    Sort_Field_Separator other_key
    }
    else			# -bylabel, or no -byxxx option
    {
	## Now add a volume key too, so that identical labels
	## in a periodical bibliography (e.g., from a regular column)
	## sort in publication order.  Warnings are suppressed, because
	## we may not have journal/year/volume/number data.
	Warning_OK = 0
	other_key = jyvnpp_key(item,citation_label)
	Warning_OK = 1

	complete_sort_key = Sort_Key filepart \
	    Sort_Field_Separator citation_label \
	    Sort_Field_Separator other_key
    }

    gsub(Visible_Newline," ",complete_sort_key)	# change all visible newlines to spaces
    gsub(/ +/," ",complete_sort_key)		# and collapse multiple spaces

    print complete_sort_key Hidden_Newline
    printf("%s", item)

    ## Check for use of crossref = "citation-key": such items must be
    ## sorted last, like @Proceedings.  This will only succeed if the
    ## input bibliography file follows the requirement of BibTeX 0.99
    ## that cross-referenced items must follow items that
    ## cross-reference them.
    v = value(item,citation_label,"crossref[ \t]*=[ \t]*")

    if (v != Unknown_Value)
	Cross_Referenced_Item[v] = 1
}


function roman_digit_value(c, the_value)
{
    ## This code is a translation of C function roman_digit_value() in bibclean.

    if (c == "i")
	the_value = 1
    else if (c == "v")
	the_value = 5
    else if (c == "x")
	the_value = 10
    else if (c == "l")
	the_value = 50
    else if (c == "c")
	the_value = 100
    else if (c == "d")
	the_value = 500
    else if (c == "m")
	the_value = 1000
    else
	the_value = 0

    return (the_value)
}


function roman_to_integer(s, k,last_value,n,number,the_value)
{
    ## This code is a translation of C function romtol() in bibclean.

    gsub("[ \t]","",s)
    s = tolower(s)
    last_value = 0
    number = 0

    if (!match(s,"^[ivxlcdm]+$"))
	warning("invalid roman digit in [" s "]: string converted to 0")
    else
    {
	n = length(s)

	for (k = 1; k <= n; ++k)
	{
	    the_value = roman_digit_value(substr(s,k,1))

	    if (the_value == 0)
	    {
		warning("internal confusion: [" substr(s,k,1) "] is not a roman digit")
		break
	    }

	    if (the_value > last_value)
		number -= last_value
	    else
		number += last_value

	    last_value = the_value
	}

	number += last_value
    }

    ## Checked: 16 unique entries in advquantumchem.bib were correctly converted
    ## print "%% DEBUG: roman_to_integer(" s ") -> " number > "/tmp/foo.debug"

    return (number)
}


function series_volume_key(item,citation_label, v)
{
    ## Return a sort key of the form <volume>.

    v = value(item,citation_label,"volume[ \t]*=[ \t]*")
    gsub(/[^0-9].*$/,"",v) # reduce "10--12", "10/12", "10(12)" to "10", etc.

    return ( numeric_value(v) )
}


function squeeze( kbrace,kspace)
{
    sub(/^[ \t]*@[ \t]*/,"@")	# eliminate space before and after initial @
    kbrace = index($0,"{")	# eliminate space between entryname and brace
    kspace = match($0,"[ \t]")

    if (kspace < kbrace)	# then found intervening space
	sub(/[ \t]+{/,"{")	# NB: sub(), NOT gsub(), here
}


function trim()
{
    sub(/[ \t]+$/,"")
}


function value(item,citation_label,keyword_pattern, n,s,v)
{
    match(item,keyword_pattern)

    ### print "DEBUG: value() [" substr(item,RSTART,RLENGTH) "] [" item "]\n\n" >"/dev/tty"

    if (substr(item,RSTART+RLENGTH,1) == "\"") # have key = "value"
    {
	s = substr(item,RSTART+RLENGTH)
	match(s,/["][^"]*["]/)
	v = (RLENGTH > 2) ? substr(s,RSTART+1,RLENGTH-2) : Unknown_Value
    }
    else if (substr(item,RSTART+RLENGTH,1) == "{") # have key = {value}
    {
	s = substr(item,RSTART+RLENGTH)
	match(s,/{[^}]*}/)
	v = (RLENGTH > 2) ? substr(s,RSTART+1,RLENGTH-2) : Unknown_Value
    }
    else if (substr(item,RSTART+RLENGTH,1) ~ /[0-9]/) # have key = number,
    {
	s = substr(item,RSTART+RLENGTH)
	match(s,/[^,]+,/)
	v = (RLENGTH > 1) ? substr(s,RSTART,RLENGTH-1) : Unknown_Value
    }
    else if (substr(item,RSTART+RLENGTH,1) ~ /[A-Za-z]/) # have key = abbrev,
    {
	s = substr(item,RSTART+RLENGTH)
	match(s,/[^,]+,/)
	v = (RLENGTH > 1) ? substr(s,RSTART,RLENGTH-1) : Unknown_Value
    }
    else			# unexpected pattern
	v = Unknown_Value

    ## For -byday sorting, we also need to return any immediately
    ## following concatenated string in a month value.  We just grab
    ## text up to the next newline or comma, which is not rigorous, but
    ## adequate for our purposes.

    if (BYDAY && \
	(v != Unknown_Value) && \
	(substr(keyword_pattern,1,5) == "month"))
    {
	s = substr(s,RSTART+RLENGTH)

	if (match(s,/[ \t\n]*\#/) && (RSTART == 1))
	{
	    s = substr(s,RSTART+RLENGTH)
	    match(s,/[^\n,]+/)
	    v = v " # " substr(s,RSTART,RLENGTH)
	}
    }

    if ((index(v,Unknown_Value) > 0) &&
	(index(keyword_pattern,"crossref") == 0))
    {				# warn about missing values
	match(keyword_pattern,/[a-zA-Z]+/)
	warning("Missing " substr(keyword_pattern,RSTART,RLENGTH) \
	    " value in " citation_label)
    }

    return (v)
}


function warning(message)
{
    if (Warning_OK)
        print ((FILENAME == "") ? "-" : FILENAME) ":" FNR ":%%" message >"/dev/stderr"
}


function year_value(year)
{
    if (year !~ /^[12][0-9][0-9x][0-9x]$/)
	year = "9999"		# force bad years to largest 4-digit value

    return (year)
}


function ymd_key(item,citation_label, day,month,n,parts,year)
{
    ## Return a -byday 10-character key of the form YYYY<SFS>MM<SFS>DD

    day   = numeric_value(value(item,citation_label,"day[ \t]*=[ \t]*"))
    month = value(item,citation_label,"month[ \t]*=[ \t]*")
    year  = year_value(value(item,citation_label,"year[ \t]*=[ \t]*"))

    ## Expect month values like this:
    ##	jan
    ##	January
    ##	jan # " 10"
    ##	jan # "~10"
    ##	"10 " # jan
    ##	"10~" # jan
    ##	"10 January"
    ##	"10~January"
    ##	"January 10"
    ##	"January~10"
    ##	jan # { 10}
    ##	jan # {~10}
    ##	{10 } # jan
    ##	{10~} # jan
    ##	{10 January}
    ##	{10~January}
    ##	{January 10}
    ##	{January~10}

    gsub(/[{}\t\#\"~]/," ",month) # remove delimiters, ties, concatenation
    gsub(/[ ]+/," ",month)	# squeeze multiple spaces to single ones
    n = split(month,parts," ")

    #### print "DEBUG: " citation_label ": year=[" year "] month=[" month \
    #### "] n=" n " parts[1]=[" parts[1] "] parts[2]=[" parts[2] "]" >"/dev/tty"

    if (parts[1] ~ /^[a-zA-Z]+$/)
	month = Month_Number[substr(tolower(parts[1]),1,3)]
    else if (parts[2] ~ /^[a-zA-Z]+$/)
	month = Month_Number[substr(tolower(parts[2]),1,3)]
    else
	month = 99		# force bad months to largest 2-digit value

    if (day == Unknown_Value)	# then expect day in month value
    {
	if (parts[1] ~ /^[0-9]+$/)
	    day = parts[1]
	else if (parts[2] ~ /^[0-9]+$/)
	    day = parts[2]
	else
	    day = "99"		# force bad days to largest 2-digit value
    }

    ## NB: The year field is always sorted as text, rather than as a
    ## number, because it can have a value like 19xx or 20xx.

    return ( substr(year,1,4) \
	Sort_Field_Separator sprintf("%02d",month) \
	Sort_Field_Separator sprintf("%02d",day) )
}
'

## The bibliography sorting is implemented as a filter pipeline:
##
## Stage 1 (nawk) finds bib file entries and prefixes them with a line
## containing a special customized recognizable sort key, where each
## such line begins with a Ctl-E, and the file ends with Ctl-E.  The
## sort key contains unprintable characters, so as to essentially
## eliminate any possibility of confusion with bibliography data.
##
## Stage 2 (tr) turns LF into Ctl-G and Ctl-E into LF.  This hides
## line boundaries, and makes each bibliography item a separate `line'.
##
## Stage 3 (sort) sorts `lines' (i.e., bib entries), ignoring
## letter case differences.
##
## Stage 4 (tr) turns LF into Ctl-E, and Ctl-G back into LF.  This
## restores the original line boundaries.
##
## Stage 5 (tr) deletes all Ctl-E and Ctl-F characters.
##
## Stage 6 (egrep) removes the sort key lines.
##
## Finally, here is the pipeline that does all of the work:

SORT=/usr/bin/sort
/usr/bin/mawk	\
	-v BYADDRESS=$BYADDRESS \
	-v BYARTICLENO=$BYARTICLENO \
	-v BYBIBDATE=$BYBIBDATE \
	-v BYCODEN=$BYCODEN \
	-v BYDAY=$BYDAY \
	-v BYISBN10=$BYISBN10 \
	-v BYISBN13=$BYISBN13 \
	-v BYISSN=$BYISSN \
	-v BYLABEL=$BYLABEL \
	-v BYNUMBER=$BYNUMBER \
	-v BYPAGES=$BYPAGES \
	-v BYPUBLISHER=$BYPUBLISHER \
	-v BYSERIES=$BYSERIES \
	-v BYSERIESVOLUME=$BYSERIESVOLUME \
	-v BYVOLUME=$BYVOLUME \
	-v BYYEAR=$BYYEAR \
	-v REVERSE=$REVERSE \
	"$PROGRAM" \
	$FILES |
	    tr '\012\005' '\007\012' |
		LC_ALL=C $SORT -f $SORTFLAGS $OTHERSORTFLAGS |
		    tr '\007\012' '\012\005' |
			 tr -d '\005\006' |
			     egrep -v  '^%%SORTKEY:'
################################[The End]###############################
