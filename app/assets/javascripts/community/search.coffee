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

    $ =>
      @main = CStone.UJSComponents['CStone.Community.Search.Components.UI']
      @session.set('current_search', @main.refs['global-search-input'].getDOMNode().value)
      @main.setProps({model: @session})
      @main.onInputFocus() if $('.text').is(":focus")

    CStone.Shared.ScrollSpy.addCallback (scroll)=>
      scroll_past = scroll > 400
      active_main = @session.get('active_ui')=='main'
      if scroll_past && active_main
        @session.set(dropdown_visible:false)
