#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Page extends SearchNamespace.AbstractSource

  defaults:
    name:   'page'
    remote:
      url: 'http://localhost:3000/search?q=%QUERY&types=page'
      filter: (results)->
        _(results.hits.hits).map (result)->
          type:    'page' #result._type
          id:      parseInt(result._id)
          score:   result._source.score
          payload: result._source.title
          description: result._source.display_description
          path:    result._source.path
    
SearchNamespace.Sources.Page.setup()