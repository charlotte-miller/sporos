class CStone.Community.Search.Views.SuggestionsResults extends Backbone.View
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered.toJSON()
    init_help:      @session.searchState()=='pre-search'
    empty_help:     @session.searchState()=='no-results'
    current_search: @session.get('current_search')
    
  constructor: (options)->
    @parent_view = options.parent_view
    @session = CStone.Community.Search.session
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
      