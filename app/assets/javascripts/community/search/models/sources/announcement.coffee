#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Announcement extends SearchNamespace.AbstractSource

  defaults:
    name: 'announcement'
    local:  [{ payload: 'dog', id:1 }, { payload: 'pig', id:2 }, { payload: 'moose man', id:3 }]
    # remote: 'http://example.com/animals?q=%QUERY'

SearchNamespace.Sources.Announcement.setup()
