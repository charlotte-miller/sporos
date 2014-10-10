class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onFocus'
    'click  .search-button' : 'onIcon'
    'submit .search-form'   : 'onSubmit'
    'keydown .text'         : 'onInputKey'
    
  initialize: =>
    @sources_collection = CStone.Community.Search.sources
    @dropdown = new CStone.Community.Search.Views.Suggestions
      collection: CStone.Community.Search.results
      context_selector: "##{@el.id}"
      sources_collection: @sources_collection
      parent_ui: @
  
  onFocus: (e)=>
    e.preventDefault()
    @dropdown.show()
    
  onIcon: (e)=>
    e.preventDefault()
    if @dropdown.isVisible
      @dropdown.hide()
      @$('.submit').blur()
    else
      @$('.text').focus() #triggers @dropdown.show()
    
  onSubmit: (e)->
    e.preventDefault()
    # select focused result and hide
    
  onInputKey: (e)=>
    switch e.which
      when 38 #up
        e.preventDefault()
        @dropdown.collection.moveFocus('up')
      when 40 #down
        e.preventDefault()
        @dropdown.collection.moveFocus('down')
      when 39 #right
        e.preventDefault()
        $target = $(e.target)
        $target.val @currentHint()
        $target.putCursorAtEnd()
      when 9  #tab
        e.preventDefault()
        $target = $(e.target)
        $target.val @currentHint()
        $target.putCursorAtEnd()
      when 13 #enter
        e.preventDefault()
        console.log 'enter'
      when 27 #esc
        e.preventDefault()
        @dropdown.hide()
        @$('.text').blur()
        #@hint(hide)
      else
        _.defer => #breaks everything
          search_term = e.target.value
          if @current_search != search_term
            @current_search = search_term
            @sources_collection.search search_term
          
  
  currentHint: =>
    @dropdown.collection.currentFocus().get('payload')