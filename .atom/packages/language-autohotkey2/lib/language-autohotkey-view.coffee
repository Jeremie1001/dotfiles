{View} = require 'atom'

module.exports =
class LanguageAutohotkeyView extends View
  @content: ->
    @div class: 'language-autohotkey overlay from-top', =>
      @div "The LanguageAutohotkey package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "language-autohotkey:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "LanguageAutohotkeyView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
