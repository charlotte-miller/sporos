#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Event extends SearchNamespace.AbstractSource

  defaults:
    name:   'event'
    local:  [{ payload: 'Dog Day at the Park', id:11, path:'#dogs-in-the-park' }, { payload: 'pig', id:12 }, { payload: 'moose', id:13 }]
    # remote: 'http://example.com/animals?q=%QUERY'
    
SearchNamespace.Sources.Event.setup()