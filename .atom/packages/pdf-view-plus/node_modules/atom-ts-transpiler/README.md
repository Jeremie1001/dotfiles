[![Travis](https://img.shields.io/travis/smhxx/atom-ts-transpiler/master.svg)](https://travis-ci.org/smhxx/atom-ts-transpiler)
[![Version](https://img.shields.io/npm/v/atom-ts-transpiler.svg)](https://www.npmjs.com/package/atom-ts-transpiler)
[![Downloads](https://img.shields.io/npm/dt/atom-ts-transpiler.svg)](https://www.npmjs.com/package/atom-ts-transpiler)
[![CodeCov](https://codecov.io/gh/smhxx/atom-ts-transpiler/branch/master/graph/badge.svg)](https://codecov.io/gh/smhxx/atom-ts-transpiler)
[![Dependencies](https://david-dm.org/smhxx/atom-ts-transpiler/status.svg)](https://david-dm.org/smhxx/atom-ts-transpiler)
[![DevDependencies](https://david-dm.org/smhxx/atom-ts-transpiler/dev-status.svg)](https://david-dm.org/smhxx/atom-ts-transpiler?type=dev)
# atom-ts-transpiler

This package provides a simple, easily-configured compatibility layer that sits between [Atom](https://atom.io/) and the [TypeScript](https://www.typescriptlang.org/) compiler, giving Atom the ability to run packages written and distributed entirely in TypeScript. It's small (about 20 KB including documentation,) supports any version of TypeScript since 1.6, and can be set up within minutes. It even respects the compiler options specified in your tsconfig.json file automatically, without the need for any additional configuration.

This project was inspired by the GitHub team's [atom-babel6-transpiler](https://www.npmjs.com/package/atom-babel6-transpiler), and utilizes the same interface to provide Atom with the ability to transpile TypeScript code on-demand. Special thanks go to them, as well as the other Atom users and community members who helped see this project through to a stable release.

## About
<img alt="" src="https://upload.wikimedia.org/wikipedia/commons/8/80/Atom_editor_logo.svg" align="right" />
<details>
<summary><b>Why use TypeScript with Atom?</b></summary>

Because TypeScript is great! It has all of the benefits of JavaScript, with the addition of a flexible and robust type system far beyond the basic 7-8 types that exist in vanilla JS. Aside from the obvious safety benefits of strong typing, it also empowers your editor/IDE with an understanding of the types that are used in your code, meaning awesome workflow emprovements like better linting, instant type-checking, and even type-sensitive autocomplete! If you haven't tried TypeScript yet, give it a shot... it really is worth it!
</details>
<details>
<summary><b>What's a "custom package transpiler?"</b></summary>

Essentially, a custom package transpiler serves as a shim between Atom and your package, allowing Atom to `require()` files written in languages that it doesn't natively understand. In this case, it takes responsibility for your package's TypeScript files, and converts them to JavaScript on-demand. Atom then caches the transpiled code for each file, only asking for re-transpilation if the cache becomes invalid (such as when the package is updated.) If Atom already has your entire package cached, the TypeScript compiler is never even loaded, and performance-wise, it functions just as if you had written the entire package in JavaScript to begin with!

</details>
<details>
<summary><b>What sort of performance do transpiled packages get?</b></summary>

The first time a user activates your package after installing it, there may be a brief delay (sometimes about a second) as Atom converts the downloaded TypeScript source files to JavaScript. On subsequent activations, however, Atom will use the cached build output generated on the previous activation, meaning that the long-term increase in activation time is near-zero (well under 10ms even for reasonably large packages.) This small difference is mainly due to Atom confirming that the cached version of each file it requires is still valid; other than that, there is no long-term performance penalty at all vs. native JavaScript packages.
</details>
<details>
<summary><b>Can't I just transpile my package myself?</b></summary>

Yes, absolutely. In fact, *this* package is written in TypeScript and transpiled prior to publishing. However, it's a bit more complicated for Atom packages than for NPM packages, since Atom packages are hosted directly from their GitHub repo, rather than uploaded to an external package repository like npm. Users download your package exactly as it exists on your master branch, so if you want your code to be transpiled *prior to* distribution, you'll have to actually commit the transpiled output to the repo (e.g. by setting up a pre-commit hook to run `tsc`,) and the user will end up downloading both the TypeScript and JavaScript versions, anyway. With a custom transpiler, all that mess can be avoided. The transpilation of your TypeScript code is handled automatically by Atom itself, with zero performance penalty after the first time the package is installed and run.
</details>
<details>
<summary><b>How can I contribute to the project?</b></summary>

Right now, the best way to help out with `atom-ts-transpiler` is simply to *use it* and provide feedback if you feel there are any improvements that can be made. Long-term stability is one of our foremost goals, and we feel like we've achieved it; the project has 100% unit test coverage, and integration tests that are run against each new release of Atom, so there's no need to worry about your package suddenly breaking because of an update. Take it for a spin and let us know what you think! 🙂

If you'd like to contribute in a more direct way, see our [Contribution Guide](https://github.com/smhxx/atom-ts-transpiler/blob/master/.github/CONTRIBUTING.md) and [Code of Conduct](https://github.com/smhxx/atom-ts-transpiler/blob/master/.github/CODE_OF_CONDUCT.md) on GitHub. We always welcome [issues](https://github.com/smhxx/atom-ts-transpiler/issues) and [pull requests](https://github.com/smhxx/atom-ts-transpiler/pulls) from the community, if you find a bug or if you think there are improvements to be made.
</details>

## Documentation

The full documentation for `atom-ts-transpiler`, including instructions for setup and configuration, is located on the project's [GitHub Wiki](https://github.com/smhxx/atom-ts-transpiler/wiki).

## License

The source code of this project is released under the [MIT Expat License](https://opensource.org/licenses/MIT), which freely permits reuse and redistribution. Feel free to use and/or modify it in any way, provided that you include the copyright notice and terms of this license with any copies that you make.

><img src="https://upload.wikimedia.org/wikipedia/commons/3/39/Cc-public_domain_mark_white.svg" alt="Public Domain Mark" height="48px" align="left" />The contents of the [examples directory](https://github.com/smhxx/atom-ts-transpiler/tree/master/examples) are not subject to the following license, and are freely released into the public domain by their respective authors. These examples are provided as-is with no warranty of any kind, and under no circumstances shall the author(s) be held liable for damages resulting directly or indirectly from their use.

>*Copyright © 2017 "smhxx" (https://github.com/smhxx)*
>
>*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:*
>
>*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.*
>
>*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*
