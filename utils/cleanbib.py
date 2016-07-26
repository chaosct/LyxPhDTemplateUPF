import bibtexparser
from bibtexparser.bparser import BibTexParser
from bibtexparser.customization import homogeneize_latex_encoding, convert_to_unicode

if __name__ == '__main__':
	import sys
	bibfile = sys.argv[1]
	with open(bibfile) as bibtex_file:
	    parser = BibTexParser()
	    #parser.customization = homogeneize_latex_encoding
	    bib_database = bibtexparser.load(bibtex_file, parser=parser)

	for entry in bib_database.entries:
	    for k in ('file','annote','abstract'):
	        entry.pop(k,None)

	bibtex_string = bibtexparser.dumps(bib_database)

	with open(bibfile,'w') as bibtex_file:
	    #bibtex_file.write(bibtex_string)
	    bibtex_file.write(bibtex_string.encode('utf8'))

