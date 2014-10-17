class CStone.Community.Search.Views.SuggestionsResults extends Backbone.View
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered.toJSON()
    init_help: @needsInitHelp()
    empty_help: @needsEmptyHelp()
    
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
      
  needsInitHelp:  => !@collection.length && !@parent_view.parent_ui.current_search
  needsEmptyHelp: => @isSearching() && !@collection.length
  isSearching:    => @parent_view.parent_ui.current_search