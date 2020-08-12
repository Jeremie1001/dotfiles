# language-root
Grammar package for [Atom](http://atom.io) with language support for [CERN ROOT](http://root.cern.ch) scientific framework based on C++.

This grammar includes standard (core) [C++ language](https://atom.io/packages/language-c) and injects additional rules based on [ROOT coding & naming conventions](https://root.cern.ch/coding-conventions).

## Using the grammar
Since this package utilizes injections to extend  C++ language, it needs to be **active** (selected via Grammar Selector) in order to highlight the code segments properly.

In addition to automatic search of files with `.cxx`,`.cpp`,`.h`,`.C`  extensions, it also checks (optionally) if the file starts with following line `// @(#)root` as recommended  [here](https://root.cern.ch/coding-conventions#Source_file_layout).

## Contribute!
Are you a ROOT user and you miss something in current highlighting? Or do you have an idea you would like to share with fellow ROOTers?

Then report it by opening a new [issue](), attach a screenshot with a brief explanation and that's it. For highlight-related issues, it is helpfull to list active scopes of the issue. This can be done by pressing ``cmd+alt+P``.
