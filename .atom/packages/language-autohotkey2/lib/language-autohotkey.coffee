LanguageAutohotkeyView = require './language-autohotkey-view'

module.exports =
  languageAutohotkeyView: null

  activate: (state) ->
    @languageAutohotkeyView = new LanguageAutohotkeyView(state.languageAutohotkeyViewState)

  deactivate: ->
    @languageAutohotkeyView.destroy()

  serialize: ->
    languageAutohotkeyViewState: @languageAutohotkeyView.serialize()
