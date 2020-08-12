# LaTeX Tree

Document tree view for LaTeX.

![LaTeX Tree](https://raw.githubusercontent.com/raphael-cch/latex-tree/master/latex-tree-screenshot.png)

## Features
* Display a document tree according to the `part`, `chapter`, `section`, `subsection`, `subsubsection`, `paragraph` and `subparagraph` labels in a LaTeX document.
* (Hopefully) accurate generation of tree view items, taking into account comments, line breaks, weird symbols etc in the title, and will ignore commented lines in the document (see example in screenshot above).
* Clicking an item in the tree view will position the cursor (and scroll the text editor) to the corresponding position in the LaTeX file.
* Text editor would be focused after clicking on the tree view, so you can move your cursor or start typing right away (can be turned off in settings).
* The corresponding item in the tree view would be highlighted according to the current cursor position (can be turned off in settings).
* Support for multi-file LaTeX documents using `\include` and `\input` (more details [below](https://github.com/raphael-cch/latex-tree#multi-file-support))

## Basics
#### Installation
Search `latex-tree` on the 'Install' page of Settings, then click 'Install'.

#### Displaying the tree view
Use the `Latex Tree: Toggle Tree View` command in the command palette.
Alternatively, use the keybinding `ctrl-alt-m` (`cmd-alt-m` for macOS) to toggle the tree view.
[You can change the default keybinding too.](https://flight-manual.atom.io/using-atom/sections/basic-customization/#customizing-keybindings)

#### Multi-file support
This package supports LaTeX documents with multiple files using the commands
```
\include{relative-file-path}
```
or
```
\input{relative-or-absolute-file-path}
```
or `\import`, `\subimport`, `\inputfrom`, `\subinputfrom`, `\includefrom`, `\subincludefrom` (from the [import package](https://www.ctan.org/pkg/import)).
You could also specify the main root file by using the "TeX Magic Comment"
```
% !TEX root = ../main.tex
```
at the beginning of **each subfile** included by the main root file
(see the [documentation for the `latex` package](https://github.com/thomasjo/atom-latex/wiki/Overridding-Build-Settings) for more details).
This would cause the document tree to be generated from the main root file instead of the current file.

## Settings
#### Update Frequency
This is the frequency for which the document tree view should be updated.
If you experience lags when you type, try lowering the update frequency or changing to *On Save Only*.
You can choose between:<br/>
**High**: tree view will be updated very shortly after you stop typing. (note: this setting uses Atom's [`onDidStopChanging`](https://atom.io/docs/api/latest/TextEditor#instance-onDidStopChanging) event)<br/>
**Medium**: tree view will not update more than every 0.5s.<br/>
**Low**: tree view will not update more than every 2s.<br/>
**On Save Only**: tree view will only update when you save the document.

#### Focus Editor After Clicking
This could be disabled if you do not want to focus back to the current text editor after clicking an item in the tree view.

#### Highlight Tree View Item according to current Cursor Position
This could be disabled if you do not want the corresponding item in the tree view to be highlighted according to the current cursor position. If you experience lags when you move the cursor, try disabling this option.

## Issues
If you experience any problems with this package, please [open an issue on GitHub](https://github.com/raphael-cch/latex-tree/issues).

## License
GPL-3.0
```
latex-tree: Document tree view for LaTeX.
Copyright (C) 2017-2018 Raphael Chung

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```
