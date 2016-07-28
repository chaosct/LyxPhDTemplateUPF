Lyx PhD Template for Universitat Pompeu Fabra
=============================================

This is a template to generate a beautifully compliant PhD dissertation document for Universitat Pompeu Fabra, using Lyx. Lyx is awesome, beautiful and powerful as Latex, but easy! After several people asked me how I managed to write my thesis in Lyx (trust me, it was not easy) I decided to just remove all the text from it and transform it into a template that can be actually used.

The templates has all parts anyone should expect in this kind of document, including copyright notice (CC), funding notices, dedication page, aknowledgements, abstracts, index, the usual chapters, appendices (including list of publications), and other goodies.


Setup
-----

You will need LyX, a functional Latex installation, LibreOffice. On my ubuntu installation I had to install the following packages: `lyx`, `texlive-fonts-extra` and `texlive-lang-spanish`.


How to use this template
------------------------

The master document is `tesi.lyx`. It includes all the material there. You can edit any subdocument as you would normally do in Lyx. This means that only by generating the pdf (`pdf(pdflatex)` option) in this document you will get the whole thing correctly.

Just three things to take into account:

1. The cover isn't generated in Lyx. You need to edit `entrega/a4opof.odt` with LibreOffice, then save the PDF as `entrega/a4opof.pdf`. This will be automagically imported in the final PDF.
2. The publications appendix isn't generated automatically in the master document. You need to edit `publications.bib`, open `publications.lyx` and save the generated pdf as `publications.pdf` (this is the default). The resulting pdf is also automatically imported when generating the master document.
3. Do not forget to change the PDF settings in the master document (Author, Title, etc..) or I'll appear as the author in the metadata :P .You can find those settings in `document->settings...->Pdf properties`.


License
-------

You don't have to thank me in your manuscript. Use as please. I'm not responsible if you lose all your manuscript because of Lyx, or this template, etc.
