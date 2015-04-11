#= require community/search/models/abstract_source
SearchNamespace = CStone.Community.Search.Models
SearchNamespace.Sources ||= {}

class SearchNamespace.Sources.Video extends SearchNamespace.AbstractSource

  defaults:
    name:   'video'
    elasticsearch: true
    prefetch:
      url: "http://#{CStoneData.domains.origin}/search/preload?types=video"
      filter: @elasticsearchProcessor('video')
    remote:
      url: "http://#{CStoneData.domains.origin}/search?q=%QUERY&types=video"
      filter: @elasticsearchProcessor('video')
      
SearchNamespace.Sources.Video.setup()