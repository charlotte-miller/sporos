class CStone.Community.Search.Views.SuggestionsResults extends CStone.Shared.Backbone.ExtendedView
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered.toJSON()
    init_help:      @session.searchState()=='pre-search'
    empty_help:     @session.searchState()=='no-results'
    current_search: @session.get('current_search')
    
  initialize: =>
    @collection = @session.get('results')
  
  render: =>
    super
    @interval = @$('.text-spinner').textrotator()
    return @ #chain
  
  remove: =>
    super
    clearInterval(@interval)
    return @ #chain
  
  events:
    'click .suggestion'     : 'onClick'
    'mouseover .suggestion' : 'onMouseover'
  
  onClick: (e)=>
    @session.acceptHint()
    result = @collection.get(e.target.dataset.resultId)
    result.open()
  
  onMouseover: (e)=>
    result = @collection.get(e.target.dataset.resultId)
    unless result.get('focus')
      @collection.updateFocus(result)
      