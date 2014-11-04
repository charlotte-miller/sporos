class CStone.Community.Search.Views.Suggestions extends CStone.Shared.Backbone.ExtendedView
  className: 'search-suggestions'
  template: HandlebarsTemplates['suggestions']
  templateData: =>
    session: @session
  
  events:
    'click .suggestion-nav-source' : 'onNavClick'
  
  bindToCollection:
    'filtered:updated' : 'render'
    'reset:clear_all'  : 'render'
  
  initialize: =>
    @collection= @session.get('results')
    @sources_collection= @session.get('sources')
  
  onNavClick: (e)=>
    # if e.target.dataset.source == 'all' && @$('.caret:visible').length > 0
    #   $(e.target).closest('.suggestions-nav').toggleClass('expanded')
    #   return 'to prevent re-render'
    
    @collection.filterBySource(e.target.dataset.source)
    to_focus = @sources_collection.findWhere(name: @collection.current_filter() )
    @sources_collection.updateFocus(to_focus)
    @render()
    @parent_view.$('.text').focus()
