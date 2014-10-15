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
      
    @bindTo @dropdown.collection, 'filtered:updated', 'updateHint'
  
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
    specialKeyCodeMap =
      9: 'tab',
      27: 'esc',
      37: 'left',
      39: 'right',
      13: 'enter',
      38: 'up',
      40: 'down'
    
    switch specialKeyCodeMap[e.which]
      when 'up'
        e.preventDefault()
        @dropdown.collection.moveFocus('up')
      when 'down'
        e.preventDefault()
        @dropdown.collection.moveFocus('down')
      when 'right'
        e.preventDefault()
        $target = $(e.target)
        $target.val @currentHint()
        $target.putCursorAtEnd()
      when 'tab'
        e.preventDefault()
        $target = $(e.target)
        $target.val @currentHint()
        $target.putCursorAtEnd()
      when 'enter'
        e.preventDefault()
        console.log 'enter'
      when 'esc'
        e.preventDefault()
        @dropdown.hide()
        @$('.text').blur()
        #@hint(hide)
      else
        _.defer =>
          search_term = e.target.value
          if @current_search != search_term
            @current_search = search_term
            @sources_collection.search search_term
          
  
  updateHint: =>
    @$('.search-hint').val(@currentHint())
  
  currentHint: =>
    @dropdown.collection.currentFocus().get('payload')