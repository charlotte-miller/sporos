#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Page extends SearchNamespace.AbstractSource

  defaults:
    name:   'page'
    local:  [{ payload: 'dog', id:41 }, { payload: 'pig', id:42 }, { payload: 'moose', id:43 }]
    # remote: 'http://example.com/animals?q=%QUERY'
    
SearchNamespace.Sources.Page.setup()