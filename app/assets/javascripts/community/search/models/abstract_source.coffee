class CStone.Community.Search.Models.AbstractSource extends Backbone.Model
  # Interface: https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md#datasets

  STOPWORDS = """
    I a about an am are as at be by for from
    how in is it of on or that the this to
    was what when where who will with w/ the
  """.toLowerCase().split(/\s+/)
  
  initialize: =>
    _(['name']).forEach (requirement)=>
      throw Error("A Source MUST have a #{requirement}") unless @get(requirement)
    
    unless @get('title')
      name = @get('name')
      @set(title: name.charAt(0).toUpperCase() + name.slice(1))
    
    # https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md#options
    bloodhound_options =
      name:           @get 'name'
      datumTokenizer: defaultDatumTokenizer
      queryTokenizer: defaultQueryTokenizer
      dupDetector:    defaultDupDetector
      sorter:         defaultSorter
      local:          @get 'local'
      remote:         @get 'remote'
      prefetch:       @get 'prefetch'

    @bloodhound = new Bloodhound( bloodhound_options )
    @bloodhound.initialize()

  
  search: (query)=>
    @bloodhound.get query, (async_results)=>
      # unless _(async_results).isEmpty()
      processed_results = async_results # @processResults(async_results)
      CStone.Community.Search.results.updateSingleSource(@get('name'), processed_results)

  processResults: (results)->
    throw new Error "Abstract Funciton - Overwrite in child"
  
  
  # Private #########
  startPhraseTokenizer = (str, word_cap=3)-> [str.split(/\s+/, word_cap).join(' ')]
  significantWordTokenizer = (query)->
    q_array = Bloodhound.tokenizers.whitespace(query)
    q_array = _(q_array).difference( STOPWORDS )
    
  
  defaultDatumTokenizer = (datum)->
    q = datum.payload.toLowerCase()
    answer = _([
      significantWordTokenizer(q),
      startPhraseTokenizer(q)
    ]).inject(((memo,tokens)->_.union(memo,tokens)),[])
    # console.log "Data: ['#{answer.join('\', \'')}']"
    answer
  
  defaultQueryTokenizer = (query)->
    q = query.toLowerCase()
    unless query.match /\s+/
      answer = [q]
    else
      finished_words = q.match(/(.*)\s+\S*$/)[1]
      answer = _([
        significantWordTokenizer(finished_words),
        startPhraseTokenizer(q)
      ]).inject(((memo,tokens)->_.union(memo,tokens)),[])
    # console.log "Query: ['#{answer.join('\', \'')}']"
    answer


  defaultDupDetector    = (remoteMatch, localMatch)-> (remoteMatch.payload == localMatch.payload)
  defaultSorter         = (a, b) ->
    if a.score > b.score then return  1
    if a.score < b.score then -1 else 0