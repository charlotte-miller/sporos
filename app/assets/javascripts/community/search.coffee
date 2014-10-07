#= require_self
#= require_tree ./search

class CStone.Community.Search
  @Collections = {}
  @Models      = {}
  @Views       = {}
  
  #### Interface ####
  # CStone.Community.Search.init()
  # CStone.Community.Search.main
  # CStone.Community.Search.header
  # CStone.Community.Search.sources #internal
  # CStone.Community.Search.results #internal
  
  @init: =>
    @initalized = true
    
    @sources = new @Collections.Sources([
      new @Models.Sources.Announcement(),
      new @Models.Sources.Event(),
      new @Models.Sources.Ministry(),
      new @Models.Sources.Music(),
      new @Models.Sources.Page(),
      new @Models.Sources.Question(),
      new @Models.Sources.Sermon(),
    ])
    @results = new @Collections.Results()
    
    @main   = new @Views.UI( el:'#global-search'   )
    @header = new @Views.UI( el:'#headroom-search' )