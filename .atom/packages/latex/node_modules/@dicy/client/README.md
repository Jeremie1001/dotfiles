# @dicy/client

[![Build Status][travis svg]][travis]
[![Windows Build Status][appveyor svg]][appveyor]
[![Dependency Status][dependency svg]][dependency]
[![devDependency Status][devdependency svg]][devdependency]

This package is a library interface via a JSON-RPC server to DiCy, a
JavaScript/TypeScript based builder for LaTeX, knitr, Literate Agda, Literate
Haskell, and Pweave that automatically builds dependencies. DiCy parses and
filters output logs and error messages generated during build and can build
projects that utilize the following programs to process files.

-   Bibliographies — Biber, BibTeX, BibTeX8, BibTeXu, pBibTeX, upBibTeX
-   Graphics Creation — Asymptote, MetaPost
-   Image/File Conversion — dvipdfm, dvipdfmx, dvips, dvisvgm, epstopdf, pdf2ps,
    ps2pdf
-   Indexing/Glossaries — bib2gls, makeglossaries, makeindex, mendex,
    splitindex, texindy, upmendex
-   LaTeX Engines — LaTeX, LuaLaTeX, pdfLaTeX, pLaTeX, upLaTeX, XeLaTeX
-   Literate Programming/Reproducible Research — Agda, knitr, lhs2TeX,
    patchSynctex, PythonTeX, Pweave, SageTeX

More information, including installation and API documentation is available at
the [DiCy][] website.

## License

This project is licensed under the MIT License - see the LICENSE.md file for
details.

[appveyor svg]: https://ci.appveyor.com/api/projects/status/s3unjr8c90bhcd99?svg=true

[appveyor]: https://ci.appveyor.com/project/yitzchak/dicy/branch/master

[dependency svg]: https://david-dm.org/yitzchak/dicy.svg?path=packages%2Fclient

[dependency]: https://david-dm.org/yitzchak/dicy?path=packages%2Fclient

[devdependency svg]: https://david-dm.org/yitzchak/dicy/dev-status.svg?path=packages%2Fclient

[devdependency]: https://david-dm.org/yitzchak/dicy?type=dev&path=packages%2Fclient

[dicy]: https://yitzchak.github.io/dicy/

[travis svg]: https://travis-ci.org/yitzchak/dicy.svg?branch=master

[travis]: https://travis-ci.org/yitzchak/dicy
