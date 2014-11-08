class CStone.Community.Search.Views.Suggestions extends CStone.Shared.Backbone.ExtendedView
  className: 'search-suggestions'
  template: HandlebarsTemplates['suggestions']
  templateData: => session: @session
  
  initialize: =>
    @results_collection= @session.get('results')
    @sources_collection= @session.get('sources')
    # @modelEvents()
  
  events:
    'click .suggestion-nav-source' : 'onNavClick'
  
  # modelEvents: =>
  #   @listenTo @results_collection, 'reset:clear_all',  @thenReRender
  
  
  # React to DOM - Change Models
  # ----------------------------------------------------------------------
  onNavClick: (e)=>
    # if e.target.dataset.source == 'all' && @$('.caret:visible').length > 0
    #   $(e.target).closest('.suggestions-nav').toggleClass('expanded')
    #   return 'to prevent re-render'
    
    @results_collection.filterBySource(e.target.dataset.source)
    to_focus = @sources_collection.findWhere(name: @results_collection.current_filter() )
    @sources_collection.updateFocus(to_focus)
    @render()
    @parent_view.$('.text').focus()


  # React to Models - Change DOM
  # ----------------------------------------------------------------------
  # thenReRender: => @render()
  
  