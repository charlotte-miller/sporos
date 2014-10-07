class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .search-form' : 'onFocus'
    'click  .submit'      : 'onIcon'
    'submit .search-form' : 'onSubmit'
    'keyup .text'         : 'onInputChange'
    
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
    if @dropdown.isVisible then @dropdown.hide() else @dropdown.show()
    @$('.text').focus()
    
  onSubmit: (e)=>
    e.preventDefault()
    @dropdown
    
  onInputChange: (e)=>
    search_term = e.target.value
    if @current_search != search_term
      @current_search = search_term
      @sources_collection.search search_term