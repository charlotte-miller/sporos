class CStone.Community.Search.Views.SuggestionsSources extends CStone.Shared.Backbone.ExtendedView
  className:'suggestions-nav'
  template: HandlebarsTemplates['suggestions/sources']
    
  initialize: =>
    @collection         = @session.get('sources')
    @results_collection = @session.get('results')
    @throttledRender    = _.debounce(@render, 100)
    @modelEvents()
    
  modelEvents: =>
    @listenTo @results_collection, 'filtered:change',        @thenUpdateFocus
    @listenTo @results_collection, 'filtered:filters:reset', @thenUpdateFocus
  
  templateData: =>
    grouped_results = @results_collection.allGrouped()
    source_nav_data = @collection.map (source)=>
      results = grouped_results[source.get('name')]
      name:  source.get('name')
      title: source.get('title')
      count: count = (if results? then results.length else 0)
      showMe: !!(count || !(@results_collection.length))
      focusClass: if source.get('focus') then 'active' else ''

    source_nav_data.unshift
      name:  'all'
      title: 'All'
      count: @results_collection.length
      isAll:  true
      showMe: _(grouped_results).size() != 1
      focusClass: if @collection.findWhere(focus:true) then '' else 'active'
    
    return source_nav_data
    

  # React to Models - Change DOM
  # ----------------------------------------------------------------------
  thenUpdateFocus: =>
    sources  = @results_collection.sources()
    filter = if sources.length == 1 then sources[0] else @results_collection.current_filter()
    to_focus = @collection.findWhere(name: filter )
    @collection.updateFocus(to_focus)
    @render()
    
  