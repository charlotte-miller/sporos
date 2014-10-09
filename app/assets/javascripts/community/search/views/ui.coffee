class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onFocus'
    'click  .search-button' : 'onIcon'
    'submit .search-form'   : 'onSubmit'
    'keyup .text'           : 'onInputChange'
    
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
    
  onInputChange: (e)=>
    search_term = e.target.value
    if @current_search != search_term
      @current_search = search_term
      @sources_collection.search search_term