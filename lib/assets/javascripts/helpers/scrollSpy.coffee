# Touch Safe Scroll Spy
# [ Usage ]
#
# spy = CStone.Shared.ScrollSpy
# spy.addCallback (scrollTop)-> console.log("A - #{scrollTop}")
# spy.addCallback (scrollTop)-> console.log("B - #{scrollTop}")

class CStone.Shared.ScrollSpy
  instance = null
  
  @addCallback: (callback)->
    instance ?= new PrivateClass()
    instance.callbacks.push callback
  
  class PrivateClass
    constructor: ->
      @callbacks = []
      @scrollTop = null
      
      $ =>
        callbacks = @callbacks
        executeCallbacks = (e)->
          for cb in callbacks
            cb( $(this).scrollTop() )
        
        $('#main-page').on
          'touchmove': _.throttle(executeCallbacks, 200)
          'scroll':    _.throttle(executeCallbacks, 200)
      