class CStone.Community.Search.Views.Suggestions extends Backbone.View
  className: 'search-suggestions'
  template: HandlebarsTemplates['suggestions']
  templateData: =>
    results_collection: @collection
    sources_collection: @sources_collection
    parent_view: @
  
  events:
    'click .suggestion-nav-source' : 'onNavClick'
  
  bindToCollection:
    'filtered:updated' : 'render'
    'reset:clear_all'  : 'render'
  
  constructor: (options)->
    @session = CStone.Community.Search.session
    @context_selector   = options.context_selector
    @sources_collection = options.sources_collection
    @parent_view        = options.parent_view
    @isMain = (@context_selector == '#global-search')
    super
  
  render: =>
    super
    $(@context_selector).append(@el)
    _.defer =>
      if @isMain
        $mainHeader.addClass('search-focused')
        $mainHeader.velocity 'scroll',
          container: $('#main-page')
          easing:   CStone.Animation.layoutTransition.easing
          duration: CStone.Animation.layoutTransition.duration
    
  remove: =>
    super
    _.defer => $mainHeader.removeClass('search-focused') if @isMain
  
  
  onNavClick: (e)=>
    # if e.target.dataset.source == 'all' && @$('.caret:visible').length > 0
    #   $(e.target).closest('.suggestions-nav').toggleClass('expanded')
    #   return 'to prevent re-render'
    
    @collection.filterBySource(e.target.dataset.source)
    to_focus = @sources_collection.findWhere(name: @collection.current_filter() )
    @sources_collection.updateFocus(to_focus)
    @render()
    @parent_view.$('.text').focus()
    
    
  # Internal
  # ----------------------------------------------------------------------
  
  $mainHeader = $('#main-header')