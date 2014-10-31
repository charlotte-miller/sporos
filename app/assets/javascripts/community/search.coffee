#= require_self
#= require_tree ./search

class CStone.Community.Search
  @Collections = {}
  @Models      = {}
  @Views       = {}
  
  #### Interface ####
  # CStone.Community.Search.init()
  # CStone.Community.Search.session
  # CStone.Community.Search.main
  # CStone.Community.Search.header
  
  @init: =>
    @initalized = true
    
    @session = new @Models.Session
      results: []
      sources: [
        {name: 'announcement' },
        {name: 'event'        },
        {name: 'ministry'     },
        {name: 'music'        },
        {name: 'page'         },
        {name: 'question'     },
        {name: 'sermon'       },
      ]
    
    @main   = new @Views.UI( el:'#global-search'   )
    # @header = new @Views.UI( el:'#headroom-search' )