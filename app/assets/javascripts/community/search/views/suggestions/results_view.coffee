# class CStone.Community.Search.Views.SuggestionsResults extends CStone.Shared.Backbone.ExtendedView
  # className: 'suggestions'
  # template: HandlebarsTemplates['suggestions/results']
  # templateData: =>
    # results_collection: @collection.filtered.toJSON()
    # init_help:      @session.searchState()=='pre-search'
    # empty_help:     @session.searchState()=='no-results'
    # current_search: @session.get('current_search')

  # initialize: =>
    # @collection = @session.get('results')
    # @modelEvents()

  # events:
  #   'click .suggestion'     : 'onClick'
  #   'mouseover .suggestion' : 'onMouseover'

  # modelEvents: =>
  #   @listenTo @collection, 'filtered:add',    @render
  #   @listenTo @collection, 'filtered:remove', @render
  #   @listenTo @collection, 'filtered:reset',  @render
  #   @listenTo @collection, 'filtered:change:focus', @updateFocus

  # React to DOM - Change Models
  # ----------------------------------------------------------------------
  # onClick: (e)=>
  #   @session.acceptHint()
  #   result = @collection.get(e.target.dataset.resultId)
  #   result.open()
  #
  # onMouseover: (e)=>
  #   result = @collection.get(e.target.dataset.resultId)
  #   unless result.get('focus')
  #     @collection.updateFocus(result)


  # React to Models - Change DOM
  # ----------------------------------------------------------------------
  # updateFocus: (result)=>
  #   @$('.suggestion.active').removeClass('active')
  #   @$(".suggestion[data-result-id=#{result.id}]").addClass('active')

  # render: =>
  #   super
  #   @interval = @$('.text-spinner').textrotator()
  #   return @ #chain
  #
  # remove: =>
  #   super
  #   clearInterval(@interval)
  #   return @ #chain
