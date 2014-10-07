#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Sermon extends SearchNamespace.AbstractSource

  defaults:
    name:   'sermon'
    local:  [{ payload: 'dog', id:61 }, { payload: 'pig', id:62 }, { payload: 'moose', id:63 }]
    # remote: 'http://example.com/animals?q=%QUERY'