class CStone.Community.Search.Views.SuggestionsResults extends Backbone.View
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered.toJSON()
    
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