class CStone.Community.Search.Views.SuggestionsResult extends Backbone.View
  tagName: 'li'
  className: => "suggestion"
  template: HandlebarsTemplates['suggestions/result']
  templateData: =>  @model.toJSON()
  
  render: =>
    @$el.addClass('active') if @model.get('focus')
    super
    