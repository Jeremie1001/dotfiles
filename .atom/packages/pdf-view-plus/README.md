# pdf-view-plus

This package provides a PDF viewer for Atom. It is intended to replace [`pdf-view`](https://atom.io/packages/pdf-view).


## Features

This package integrates Mozilla's PDF.js platform and viewer almost directly into an Atom pane. This gives you the same set of features you find in the Firefox PDF viewer (which also uses PDF.js), and means updates upstream can be easily incorporated.

For package developers, there is also a [`pdfview`](https://github.com/Aerijo/atom-pdf-view-plus/wiki/pdfview-API) service that allows for interacting with open PDFs. The reverse SyncTeX capability of this package works using this service.


## Why not `pdf-view`

The `pdf-view` package uses the core of PDF.js but with a custom viewer. Among other issues, its viewer at the time of writing loads all pages in memory meaning large PDFs can cause severe performance issues. There is also an undiagnosed memory leak, causing RAM usage to rise with every reloaded PDF. This is not a problem for light use, but it can lead to a crash when frequently reloading PDFs, such as when recompiling LaTeX.

In comparison, the Mozilla viewer loads only visible pages, and has the PDF.js team behind it to patch any memory leaks. Loading only visible pages means they may take a moment to render when randomly accessed, but the overall performance is much better in large files.


## Installing

Do this through the Atom settings tab, or on the command line with
```
apm install pdf-view-plus
```

Alternatively, you can use `apx` to install a reduced size version; the `apm` install is 70MB, while installing via `apx` is only 7MB.

To install `apx`, first install `npm` and then [apx](https://www.npmjs.com/package/@aerijo/apx) with the following command
```
npm install -g @aerijo/apx
```
then to install `pdf-view-plus` run
```
apx install pdf-view-plus
```


## Developing

1. Clone repo & navigate to repo root
2. Run `npm install`
4. Run `apm link --dev`
3. Run `npm run watch` (keeps TS compiled)
5. Open PDF in dev mode & reload window to test changes each time
