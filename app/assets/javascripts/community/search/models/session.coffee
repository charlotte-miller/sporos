class CStone.Community.Search.Models.Session extends Backbone.RelationalModel

  relations: _([
    {
      type:            'HasMany'
      key:             'results'
      relatedModel:    'CStone.Community.Search.Models.Result'
      collectionType:  'CStone.Community.Search.Collections.Results'
    },
    {
      type:            'HasMany'
      key:             'sources'
      relatedModel:    'CStone.Community.Search.Models.AbstractSource'
      collectionType:  'CStone.Community.Search.Collections.Sources'
    }
  ]).map (relation)-> _(relation).extend(reverseRelation: {key:'session', type:'HasOne'})

  defaults:
    current_search:''
  
  initialize: =>
    @on 'change:current_search', @_onChangeCurrentSearch
  
  state: =>
    is_searching = !!@get('current_search')
    return 'pre-search'   unless is_searching
    return 'searching'    if is_searching && @get('results').length
    return 'no-results'   if is_searching
  
  _onChangeCurrentSearch: =>
    query = @get('current_search')
    if query
      @get('sources').search(query)
    else 
      if @previous('current_search') #Not initialize
        @get('results').reset()
        @get('results').trigger('reset:clear_all')

    
CStone.Community.Search.Models.Session.setup()