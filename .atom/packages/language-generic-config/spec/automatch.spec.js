'use strict'

const {expectScopeToBe, getEditor, waitToOpen} = require('./helpers')
const {join} = require("path")

describe('Auto-matching', function(){
  const nullScope    = 'text.plain.null-grammar'
  const packageScope = 'text.generic-config'
  const textScope    = 'text.plain'
  const shellScope   = 'source.shell'
  const gitConfScope = 'source.git-config'
  const optEnable    = 'language-generic-config.enableAutomatch'
  const optRegExp    = 'language-generic-config.automatchPattern'
  const optMinLines  = 'language-generic-config.requireMinimumMatchingLines'
  let grammarPackage
  let atomEnv

  beforeEach(function(){
    atomEnv = global.buildAtomEnvironment()
    grammarPackage = atom.packages.loadPackage(join(__dirname, ".."))
    return Promise.all([
      atom.packages.activatePackage('language-text'),
      atom.packages.activatePackage('language-shellscript'),
      atom.packages.activatePackage('language-git'),
      grammarPackage.activate(),
    ]).then(() => {
      const textGrammar    = atom.grammars.grammarForScopeName(textScope)
      const packageGrammar = atom.grammars.grammarForScopeName(packageScope)
      const shellGrammar   = atom.grammars.grammarForScopeName(shellScope)
      const gitGrammar     = atom.grammars.grammarForScopeName(gitConfScope)
      expect(textGrammar).to.exist
      expect(packageGrammar).to.exist
      expect(shellGrammar).to.exist
      expect(gitGrammar).to.exist
    })
  })

  afterEach(function(){
    atomEnv.destroy()

    // Reset package options after each spec
    atom.config.set(optEnable, true)
    atom.config.set(optRegExp, "^\\s*[;#]\\s")
    atom.config.set(optMinLines, 2)
  })

  describe('when opening an unrecognised file-format', () => {
    describe('when the file has no comment-lines', () => {
      it('uses the null-grammar (auto-detect)', () => {
        return waitToOpen('normal.file').then(() => {
          const editor = getEditor()
          expect(editor).to.exist
          expect(editor.getGrammar()).to.exist
          return expectScopeToBe(nullScope)
        })
      })
    })

    describe('when the file has comments starting with `#`', () => {
      it('enables the `generic-config` grammar', () => {
        return waitToOpen('unix-config').then(() => {
          expect(atom.config.get(optEnable)).to.equal(true)
          expectScopeToBe(packageScope)
        })
      })
    })

    describe('when the file has comments starting with `;`', () => {
      it('enables the `generic-config` grammar', () => {
        return waitToOpen('win32-config').then(() => {
          expectScopeToBe(packageScope)
        })
      })
    })
  })

  describe('when opening a recognised file-format', () => {
    describe('when the format uses `#` to introduce comments', () => {
      it("uses the format's grammar", () => {
        return waitToOpen('exec.sh').then(() => {
          expectScopeToBe(shellScope)
        })
      })
    })

    describe('when the format uses `;` to introduce comments', () => {
      it("uses the format's grammar", () => {
        return waitToOpen('semicolons.gitconfig').then(() => {
          expectScopeToBe(gitConfScope)
        })
      })
    })
  })

  describe('Package settings', () => {
    describe('when the user disables the `enableAutomatch` setting', () => {
      beforeEach(() => {
        return waitToOpen('another-config').then(() => {
          expectScopeToBe(packageScope)
        })
      })

      it('clears all grammar overrides assigned by the package', () => {
        expectScopeToBe(packageScope)
        atom.config.set(optEnable, false)
        expectScopeToBe(nullScope)
        atom.config.set(optEnable, true)
        expectScopeToBe(nullScope)
      })
    })
  })
})
