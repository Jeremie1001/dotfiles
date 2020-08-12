# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-text-editor', 'custom:top-barrier', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.selectLinesContainingCursors()
  editor.copySelectedText()
  editor.cutSelectedText()
  clipboardText = atom.clipboard.read()

  clipboardText = clipboardText.replace(/^\s+|\s+$/g, '');

  if clipboardText != ""
    lengthBefore = Math.ceil(clipboardText.length/2)
    before = "//"

    i = 0
    while (i < (50 - lengthBefore))
      before = before.concat("-")
      i = i + 1

    editor.insertText("#{before}")


    editor.insertText("#{clipboardText}")


    lengthAfter = Math.floor(clipboardText.length/2)
    after = ""

    i = 0
    while (i < (50 - lengthAfter))
      after = after.concat("-")
      i = i + 1

    after = after.concat("//")
    editor.insertText("#{after}\n")

atom.commands.add 'atom-text-editor', 'custom:bottom-barrier', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.selectLinesContainingCursors()
  editor.copySelectedText()
  editor.cutSelectedText()
  clipboardText2 = atom.clipboard.read()


  editor.insertText("#{clipboardText2}")
