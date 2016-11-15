path = require 'path'
temp = require 'temp'

describe 'Settings', ->
  editor = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    filePath = path.join(directory, 'atom.diff')

    waitsForPromise ->
      atom.workspace.open(filePath).then (o) -> editor = o
    waitsForPromise ->
      atom.packages.activatePackage('whitespace')
    waitsForPromise ->
      atom.packages.activatePackage('language-diff')

  it 'loads both packages', ->
    expect(atom.packages.isPackageActive('whitespace')).toBe true
    expect(atom.packages.isPackageActive('language-diff')).toBe true

  it 'sets the grammar', ->
    expect(editor.getGrammar().name).toBe 'Diff'

  it 'sets the whitespace config to false', ->
    expect(atom.config.get('whitespace.removeTrailingWhitespace', scope: ['.source.diff'])).toBe false

  it 'does not trim trailing whitespace', ->
    editor.insertText "+def fib(n, sequence = [1])    \n"
    editor.save()
    expect(editor.getText()).toBe "+def fib(n, sequence = [1])    \n"
