(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("MastersDoctoralThesis" "11pt" "oneside" "english" "onehalfspacing" "headsepline" "")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("biblatex" "backend=bibtex" "style=authoryear" "natbib=true") ("csquotes" "autostyle=true") ("caption" "font={small}") ("subfig" "caption=false")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (TeX-run-style-hooks
    "latex2e"
    "MastersDoctoralThesis"
    "MastersDoctoralThesis11"
    "inputenc"
    "fontenc"
    "mathpazo"
    "biblatex"
    "csquotes"
    "enumitem"
    "listings"
    "graphicx"
    "xcolor"
    "amsmath"
    "caption"
    "varwidth"
    "supertabular"
    "subfig"
    "wrapfig"
    "mathtools")
   (LaTeX-add-environments
    "blueparagraph"
    "nscenter")
   (LaTeX-add-bibliographies
    "related_work"))
 :latex)

