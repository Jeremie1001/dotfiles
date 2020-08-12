### 0.5.0 - Support for more import commands
* Support for the [import package](https://www.ctan.org/pkg/import): commands `\import`, `\subimport`, `\inputfrom`, `\subinputfrom`, `\includefrom`, `\subincludefrom`
* Bug fix for incorrect file path behaviour when `\input`s are nested

### 0.4.0 - Support for folding tree structure
* Tree structure can now be folded by clicking the arrow

### 0.3.0 - Support for multi-file documents
* Added support for documents with multiple files, see the [relevant section in readme](https://github.com/raphael-cch/latex-tree#multi-file-support) for more details

### 0.2.1 - Bugfix
* Minor bug fix: TypeError when there is nothing in the document tree

### 0.2.0 - Option to disable highlighting and bug fixes
* Added config option to disable highlighting of tree view with cursor position
* Bug fixes:
    * text editor not focused if mouse is moved while pressed down
    * tree view not always displayed on pane change
    * highlighting behavior misleading when cursor is in preamble / top matter
* Other minor improvements

### 0.1.0 - Initial Release
* Basic features including:
    * generating document tree and displaying tree view
    * clicking tree view to bring you to corresponding position in document
    * config options to change frequency of tree update
    * focusing text editor after clicking (can be turned off in settings)
    * highlighting corresponding item in tree view according to current cursor position
