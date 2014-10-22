class CStone.Community.Search.Views.SuggestionsResults extends Backbone.View
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered.toJSON()
    init_help: @state()=='pre-search'
    empty_help: @state()=='no-results'
    current_search: @currentSearch()
    
  constructor: (options)->
    @parent_view = options.parent_view
    super
  
  render: =>
    super
    @interval = @$('.text-spinner').textrotator()
      # callback: ->
  
  remove: =>
    clearInterval(@interval)
    super
  
  events:
    'click .suggestion'     : 'onClick'
    'mouseover .suggestion' : 'onMouseover'
  
  onClick: (e)=>
    result = @collection.get(e.target.dataset.resultId)
    result.open()
  
  onMouseover: (e)=>
    result = @collection.get(e.target.dataset.resultId)
    unless result.get('focus')
      @collection.updateFocus(result)
  
  currentSearch: =>
    @parent_view.parent_view.current_search
  
  state: =>
    is_searching = !!@currentSearch()
    return 'pre-search'   unless is_searching
    return 'searching'    if is_searching && @collection.length
    return 'no-results'   if is_searching
    