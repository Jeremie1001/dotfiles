'use strict'

const {CompositeDisposable, Disposable} = require('atom')
const PACKAGE_NAME = 'language-generic-config'
const PACKAGE_SCOPE = 'text.generic-config'
const OPT_AM_ENABLE = `${PACKAGE_NAME}.enableAutomatch`
const OPT_AM_REGEXP = `${PACKAGE_NAME}.automatchPattern`
const OPT_MIN_LINES = `${PACKAGE_NAME}.requireMinimumMatchingLines`

let autoMatchEnabled = undefined
let autoMatchPattern = /^\s*[;#]\s/gm
let editorObserver = null

module.exports = {
  activate(){
    this.affectedEditors = new Map()
    this.disposables = new CompositeDisposable(
      atom.config.observe(OPT_AM_REGEXP, value => {
        this.autoMatchPattern = new RegExp(value, 'gm')
      }),
      atom.config.observe(OPT_AM_ENABLE, value => value
        ? this.enableAutoMatch()
        : this.disableAutoMatch()
      )
    )
  },

  deactivate(){
    this.disposables.dispose()
    this.disposables = null
    this.affectedEditors.clear()
    this.affectedEditors = null
  },

  /**
   * Register handlers to respond to files which quack like configs.
   * @internal
   */
  enableAutoMatch(){
    if(autoMatchEnabled) return
    autoMatchEnabled = true

    // Duplicate observers shouldn't exist… but better safe than sorry.
    if(this.editorObserver)
      this.editorObserver.dispose()

    this.editorObserver = atom.workspace.observeTextEditors(editor => {
      // Only check editor's contents after a brief timeout, so other language
      // packages have a chance to do what we're doing (matching based on content).
      setTimeout(() => {
        if(this.canAutoMatch(editor) && this.testAutoMatch(editor))
          this.assignGrammar(editor)
      }, 100)
    });
  },

  /**
   * Disable the package's auto-matching feature.
   *
   * Note that due to an (apparent) bug with Atom's highlighting, it's not
   * possible to remove a file's highlighting when assigning {@link NullGrammar}.
   * @internal
   */
  disableAutoMatch(){
    if(!autoMatchEnabled && null == autoMatchEnabled) return
    autoMatchEnabled = false

    if(this.affectedEditors.size){
      const entries = Array.from(this.affectedEditors)
      for(const [editor, disposables] of entries){
        disposables.dispose()
        this.affectedEditors.delete(editor)
      }
    }

    if(this.editorObserver){
      this.editorObserver.dispose()
      this.editorObserver = null
    }
  },

  /**
   * Determine whether a {@link TextEditor} can be overridden by the package.
   *
   * @param {TextEditor} editor
   * @return {Boolean}
   * @internal
   */
  canAutoMatch(editor){
    return atom.workspace.isTextEditor(editor)
      && editor.isAlive()
      && !this.affectedEditors.has(editor)
      && !atom.textEditors.getGrammarOverride(editor)
      &&  atom.grammars.nullGrammar === editor.getGrammar()
  },

  /**
   * Execute the `autoMatch` pattern against an editor's contents.
   * 
   * @param {TextEditor} editor
   * @return {Boolean} Whether the file appears to be a generic-config file
   * @internal
   */
  testAutoMatch(editor){
    const text = editor.getText() || ''
    const matches = text.match(this.autoMatchPattern) || []
    return matches.length >= atom.config.get(OPT_MIN_LINES)
  },

  /**
   * Override an editor's language-type with the `generic-config` grammar.
   *
   * This method also configures event listeners to undo the override
   * when closing the editor, or manually assigning a different grammar.
   * Doing this ensures auto-matched files won't take precedence over a
   * language package which may be installed later. It also makes sure the
   * overridden paths don't bloat the serialised project's metadata.
   * 
   * @param {TextEditor} editor
   * @return {CompositeDisposables}
   * @internal
   */
  assignGrammar(editor){

    // Run a quick sanity check to avoid doubling our listeners
    let disposables = this.affectedEditors.get(editor)
    if(disposables)
      return disposables

    disposables = new CompositeDisposable(
      new Disposable(() => {
        atom.textEditors.clearGrammarOverride(editor)
        this.affectedEditors.delete(editor)
      }),
      editor.onDidChangeGrammar(grammar => {
        if(grammar && grammar.scopeName !== PACKAGE_SCOPE)
          this.unassignGrammar(editor)
      }),
      editor.onDidDestroy(() => this.unassignGrammar(editor))
    )
    this.affectedEditors.set(editor, disposables)
    atom.textEditors.setGrammarOverride(editor, PACKAGE_SCOPE)
    return disposables
  },

  /**
   * Remove the grammar override tied to a specific editor.
   * 
   * @param {TextEditor}
   * @internal
   */
  unassignGrammar(editor){
    if(!this.affectedEditors)
      return
    const disposables = this.affectedEditors.get(editor)
    if(disposables)
      disposables.dispose()
  },
}
