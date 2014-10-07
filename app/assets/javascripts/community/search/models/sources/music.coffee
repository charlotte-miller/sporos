#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Music extends SearchNamespace.AbstractSource

  defaults:
    name:   'music'
    local:  [{ payload: 'dog', id:31 }, { payload: 'pig', id:32 }, { payload: 'moose', id:33 }]
    # remote: 'http://example.com/animals?q=%QUERY'