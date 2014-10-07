#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Ministry extends SearchNamespace.AbstractSource

  defaults:
    name:   'ministry'
    local:  [{ payload: 'doggy', id:21 }, { payload: 'pig', id:22 }, { payload: 'moose', id:23 }]
    # remote: 'http://example.com/animals?q=%QUERY'