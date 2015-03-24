#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.SiteContent extends SearchNamespace.AbstractSource

  defaults:
    name:   'site_content'
    remote: 
      url: 'http://localhost:3000/search?q=%QUERY'
      filter: (results)->
        _(results.hits.hits).map (result)->
          type:    'page' #result._type
          id:      parseInt(result._id)
          score:   result._source.score
          payload: result._source.title
          description: result._source.display_description
          path:    result._source.path
    
SearchNamespace.Sources.SiteContent.setup()