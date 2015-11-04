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
      @main.setProps({model: @session, ui_name:'main'})
      @main.onInputFocus() if $('.text').is(":focus")

      theater = theaterJS()
      actor = theater.addActor 'search', {speed:1.1, accuracy:0.8}, (displayValue)->
        $('#global-search-input').attr('placeholder', displayValue)

      theater.addScene 1000
      theater.addScene('search:')
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'Hi! What are you looking for?'
        done()
      theater.addScene 300
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'Hi!What are you looking for?'
        done()
      theater.addScene 100
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'HiWhat are you looking for?'
        done()
      theater.addScene 200
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'HWhat are you looking for?'
        done()
      theater.addScene 100
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = 'What are you looking for?'
        done()
      theater.addScene(500, ' I can help',400,'!!',300, '!',1500)
      theater.addScene (done)->
        actor.getCurrentActor().displayValue = ''
        done()
      theater.addScene('search:Scroll down to explore the community',1500)
      theater.addScene('... or',800)
      theater.addScene (done)->
        actor.getCurrentActor().displayValue = ''
        done()
      # theater.addScene('search:Click here to search our music, messages, and events', 1200)
      # theater.addScene (done)->
      #   actor.getCurrentActor().displayValue = ''
      #   done()
      theater.addScene('search:Click here to search by name', 800)
      theater.addScene (done)->
        actor.getCurrentActor().displayValue = ''
        done()
      theater.addScene('Or a topic like "forgiveness"', 800)
      theater.addScene(-12)
      theater.addScene('parenting"', 800)
      theater.addScene(-11)
      theater.addScene('or "grief"', 1500)
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = ''
        done()
      theater.addScene('I can even answer common questions', 100,'.',100,'.',500,'.', )
      theater.addScene(' so give it a try!',5000)
      theater.addScene (done)->
        search = actor.getCurrentActor()
        search.displayValue = ''
        done()
      theater.addScene('search:What are you looking for?', 1000)
      theater.play()


    CStone.Shared.ScrollSpy.addCallback (scroll)=>
      scroll_past = scroll > 400
      active_main = @session.get('active_ui')=='main'
      if scroll_past && active_main
        @session.set(dropdown_visible:false)
