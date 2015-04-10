#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Ministry extends SearchNamespace.AbstractSource

  defaults:
    name:   'ministry'
    local:  [{ payload: 'doggy', id:21 }, { payload: 'pig', id:22 }, { payload: 'moose', id:23 }]
    # elasticsearch: true
    # remote:
    #   url: "http://#{CStoneData.domains.origin}/search?q=%QUERY&types=ministry"
    #   filter: @elasticsearchProcessor('ministry')

SearchNamespace.Sources.Ministry.setup()