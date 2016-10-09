describe 'Diff grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-diff')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.diff')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.diff'

  it 'tokenizes spaces', ->
    {tokens} = grammar.tokenizeLine(' ')
    expect(tokens[0]).toEqual value: ' ', scopes: ['source.diff']

  it 'tokenizes separators', ->
    {tokens} = grammar.tokenizeLine('***************')
    expect(tokens[0]).toEqual value: '***************', scopes: [
      'source.diff', 'meta.separator.diff', 'punctuation.definition.separator.diff'
    ]

    {tokens} = grammar.tokenizeLine('===================================================================')
    expect(tokens[0]).toEqual value: '===================================================================', scopes: [
      'source.diff', 'meta.separator.diff', 'punctuation.definition.separator.diff'
    ]

    {tokens} = grammar.tokenizeLine('---')
    expect(tokens[0]).toEqual value: '---', scopes: [
      'source.diff', 'meta.separator.diff', 'punctuation.definition.separator.diff'
    ]

  it 'tokenizes entries `Only in`', ->
    {tokens} = grammar.tokenizeLine('Only in new_version: a.txt')
    expect(tokens[0]).toEqual value: 'Only in new_version: a.txt', scopes: [
      'source.diff', 'meta.diff.only-in'
    ]
