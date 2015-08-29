#= require_self
#= require_tree ./search

class CStone.Community.Search
  @Collections = {}
  @Models      = {}
  @Views       = {}
  @Components  = {}

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
        {name: 'video'        },
        {name: 'page'         },
        {name: 'question'     },
        {name: 'sermon'       },
      ]

    # @main   = new @Views.UI( ui_name: 'main',   el:'#main-header' )
    # @header = new @Views.UI( ui_name: 'header', el:'#headroom'    )

    @main   = React.render(React.createElement(@Components.UI, {model: @session}), $('#main-header')[0])

    CStone.Shared.ScrollSpy.addCallback (scroll)=>
      scroll_past = scroll > 400
      active_main = @session.get('active_ui')=='main'
      if scroll_past && active_main
        @session.set(dropdown_visible:false)
