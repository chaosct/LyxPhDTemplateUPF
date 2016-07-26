#!/usr/bin/env sh
#utils/bibsort.sh library.bib >library.bib.new
#mv library.bib.new library.bib
#sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' library.bib > library.bib.new
#mv library.bib.new library.bib
#eliminar camps conflictius
#perl -n -e "print unless /^(file|annote)/" library.bib > library.bib.new
#mv library.bib.new library.bib

python utils/cleanbib.py library.bib
python utils/cleanbib.py publications.bib
