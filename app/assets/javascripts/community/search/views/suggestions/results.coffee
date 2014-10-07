class CStone.Community.Search.Views.SuggestionsResults extends Backbone.View
  className: 'suggestions'
  template: HandlebarsTemplates['suggestions/results']
  templateData: =>
    results_collection: @collection.filtered
    
  events:
    'keyNorth' : ''
    'keySouth' : ''
    'keyEast'  : ''
    'keyWest'  : ''
  
  # track selected suggestion
  # render collections
  # delegate execution to the model
  