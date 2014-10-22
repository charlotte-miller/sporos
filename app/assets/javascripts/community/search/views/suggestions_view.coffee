class CStone.Community.Search.Views.Suggestions extends Backbone.View
  className: 'search-suggestions'
  template: HandlebarsTemplates['suggestions']
  
  bindToCollection:
    'filtered:updated' : 'render'
    'reset:clear_all'  : 'render'
  
  events:
    'click .suggestion-nav-source' : 'onNavClick'
    
  
  constructor: (options)->
    @context_selector   = options.context_selector
    @sources_collection = options.sources_collection
    @parent_view          = options.parent_view
    @isMain = (@context_selector == '#global-search')
    super
  
  render: =>
    super
    $(@context_selector).append(@el)
  
  templateData: =>
    results_collection: @collection
    sources_collection: @sources_collection
    parent_view: @
  
  show: =>
    @isVisible = true
    @render()
    _.defer =>
      if @isMain
        $mainHeader.addClass('search-focused')
        $mainHeader.velocity 'scroll',
          container: $('#main-page')
          easing:   CStone.Animation.layoutTransition.easing
          duration: CStone.Animation.layoutTransition.duration
        
        CStone.Shared.ScrollSpy.addCallback (scroll)=>
          if scroll > 400
            @hide()
            @parent_view.$('.text').blur()
    
  hide: =>
    @isVisible = false
    @remove()
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
    
    
  # Internal #################################
      
  $mainHeader = $('#main-header')