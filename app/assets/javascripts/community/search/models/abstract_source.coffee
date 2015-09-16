class CStone.Community.Search.Models.AbstractSource extends Backbone.RelationalModel
  STOPWORDS = """
    I a about an am are as be by for from
    how in is it of on or that the this to
    was what when where who will with w/ the
  """.toLowerCase().split(/\s+/)

  REPLACEMENTS = [
    ['@', 'at'],
    ['&', 'and'],
    [',', ''],
    ['\\+', 'and'],
    ['[\\[|\\(|\\)|\\]]', ''],   # ()
    ['\\s?-\\s?', ' '],          # -
    ['\\s?:', ''],               # :
  ]

  subModelTypeAttribute: 'name'
  subModelTypes:
    'event'        : 'CStone.Community.Search.Models.Sources.Event'
    'ministry'     : 'CStone.Community.Search.Models.Sources.Ministry'
    'combined'     : 'CStone.Community.Search.Models.Sources.Combined'
    'music'        : 'CStone.Community.Search.Models.Sources.CombinedAdapter'
    'video'        : 'CStone.Community.Search.Models.Sources.CombinedAdapter'
    'page'         : 'CStone.Community.Search.Models.Sources.CombinedAdapter'
    'question'     : 'CStone.Community.Search.Models.Sources.CombinedAdapter'
    'sermon'       : 'CStone.Community.Search.Models.Sources.CombinedAdapter'


  initialize: =>
    _(['name']).forEach (requirement)=>
      throw Error("A Source MUST have a #{requirement}") unless @get(requirement)

    unless @get('title')
      name = @get('name')
      @set(title: name.charAt(0).toUpperCase() + name.slice(1))

    # https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md#options
    bloodhound_options =
      name:           @get 'name'
      datumTokenizer: @defaultDatumTokenizer
      queryTokenizer: @defaultQueryTokenizer
      identify:       identifyDatum
      sorter:         defaultSorter
      sufficient:     10
      local:          @get 'local'
      remote:         @get 'remote'
      prefetch:       @get 'prefetch'

    @bloodhound = new Bloodhound( bloodhound_options )

  search: (query)=>
    handleLocalSearch = (datums)=>
      console.log(["#{@get('title')} Local: #{query}", datums])
      @get('session').get('results').updateFromSource( @processResults(datums), @ )

    handleRemoteSearch = (datums)=>
      if @get('elasticsearch')
        @bloodhound.add(datums)
        datums = @bloodhound.index.search(query)
      console.log(["#{@get('title')} Remote #{query}", datums])
      @get('session').get('results').updateFromSource( @processResults(datums), @ )

    @bloodhound.search query, handleLocalSearch, handleRemoteSearch

  processResults: (results)-> results # Abstract Funciton - Overwrite in child

  defaultDatumTokenizer: (datum)->
    q = datum.payload.toLowerCase().trim()
    q = charFilter(q)
    answer = _([
      [q],
      # significantWordTokenizer(q),
      # edgeNgramTokenizer(q),
    ]).inject(((memo,tokens)->_.union(memo,tokens)),[])
    console.log "Data: ['#{answer.join('\', \'')}']"
    answer

  defaultQueryTokenizer: (query)->
    q = query.toLowerCase().trim()
    q = charFilter(q)
    unless query.match /\s+/
      answer = [q]
    else
      answer = _([
        [q],
        # significantWordTokenizer(q),
        # recentHistoryTokenizer(q), #trailing history
      ]).inject(((memo,tokens)->_.union(memo,tokens)),[])
    console.log "Query: ['#{answer.join('\', \'')}']"
    answer

  # Internal #########
  edgeNgramTokenizer = (str, word_cap=5)->
    gram = ''
    collection = str.split(/\s+/, word_cap).join(' ').split('')
    _(collection).map (letter, i)-> gram += letter

  shingle = (collection, size) ->
    shingles = []
    i = 0
    while i < collection.length - size + 1
      shingles.push collection.slice(i, i + size)
      i++
    shingles

  significantWordTokenizer = (query)->
    q_array = Bloodhound.tokenizers.whitespace(query)
    q_array = _(q_array).difference( STOPWORDS )

  charFilter = (str)->
    _(REPLACEMENTS).each (pair)->
      [regex, replacement] = pair
      str= str.replace(///#{regex}///g, replacement)
    str


  identifyDatum = (datum)-> datum.id
  defaultSorter = (a, b) ->
    if a.score > b.score then return  1
    if a.score < b.score then -1 else 0

  # Singletons ##########
  @elasticsearchProcessor: (results)->
    results_array = _(results.hits.hits).map (result)->
      type:    result._type
      id:      parseInt(result._id)
      score:   result._score
      payload: result._source.title
      description: result._source.display_description
      path:    result._source.path
    results_array.total_counts = results.total_counts
    results_array

CStone.Community.Search.Models.AbstractSource.setup()
