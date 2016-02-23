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

    $ =>
      @main = CStone.UJSComponents['CStone.Community.Search.Components.UI']
      @session.set('current_search', @main.refs['global-search-input'].getDOMNode().value)
      @main.setProps({model: @session, ui_name:'main'})
      @main.onInputFocus() if $('.text').is(":focus")

      theater = theaterJS()
      actor = theater.addActor 'search', {speed:1.1, accuracy:0.8}, (displayValue)->
        $('#global-search-input').attr('placeholder', displayValue)

      theater.addScene('search:')
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'Search for music, messages, events and more...'
        done()
      theater.addScene 2000
      theater.addScene (done)->
        actor.getCurrentActor().displayValue = ''
        done()
      theater.addScene('search:Try searching a topic like', ' "forgiveness"', 800)
      theater.addScene(-12)
      theater.addScene('parenting"', 800)
      theater.addScene(-11)
      theater.addScene('or "grief".', 1500, ' Or...',1200)
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = ''
        done()
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = ''
        done()
      theater.addScene('search:Scroll down to explore the community',3000)
      theater.addScene('search:Search for music, messages, events and more...',1500)
      # theater.addScene (done)->
      #   actor.getCurrentActor().displayValue = 'Search for music, messages, events and more...'
      #   done()

      _.delay theater.play, 800


    CStone.Shared.ScrollSpy.addCallback (scroll)=>
      scroll_past = scroll > 400
      active_main = @session.get('active_ui')=='main'
      if scroll_past && active_main
        @session.set(dropdown_visible:false)
