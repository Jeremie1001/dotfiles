const path = require('path')
let editor = null

module.exports = {
  getEditor: () => editor,
  open,
  expectScopeToBe,
  wait,
  waitToOpen,
  waitToSettle,
}

function open(fileName){
  const projectPath = path.join(__dirname, 'fixtures', fileName)
  return atom.workspace.open(projectPath).then(openedEditor =>
    Promise.resolve(editor = openedEditor))
}

function expectScopeToBe(...args){
  const grammar = editor.getGrammar()
  return expect(grammar ? grammar.scopeName : '').to.equal(...args)
}

function wait(delay = 100){
  return new Promise(resolve => {
    setTimeout(() => resolve(), delay)
  })
}

function waitToSettle(){
  return new Promise(done => {
    if(editor.buffer.stoppedChangingTimeout){
      const cd = editor.onDidStopChanging(() => {
        cd.dispose()
        done(editor)
      })
    }
    else done(editor)
  })
}

function waitToOpen(fixtureFile){
  return new Promise(done => {
    return open(fixtureFile)
      .then(() => waitToSettle())
      .then(() => done())
  })
}
