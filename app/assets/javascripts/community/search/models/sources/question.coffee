#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Question extends SearchNamespace.AbstractSource

  defaults:
    name:   'question'
    local:  [{ payload: 'dog', id:51 }, { payload: 'pig', id:52 }, { payload: 'moose', id:53 }]
    # remote: 'http://example.com/animals?q=%QUERY'