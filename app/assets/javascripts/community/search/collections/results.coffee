#= require community/search/models/result

class CStone.Community.Search.Collections.Results extends CStone.Shared.Backbone.ExtendedCollection
  model: CStone.Community.Search.Models.Result
  
  constructor: (models=[], other_options={})->
    # https://github.com/jmorrell/backbone-filtered-collection
    super
    @filtered = new FilteredCollection(@)
    @filtered.grouped = -> @groupBy('source')
    @filtered.sources = -> @pluck('source')
    @throttledHandleUpdates = _.debounce @handleUpdates, 100
    @updateFocus()
  

  
  # Convience Queries
  # ----------------------------------------------------------------------
  grouped: => @filtered.grouped()
  sources: => @filtered.sources()
  allGrouped: => @groupBy('source')
  allSources: => @pluck('source')
  
  currentFocus: =>
    @filtered.findWhere(focus:true)
  
  current_filter: =>
    _filters = @filtered.getFilters()
    return 'all' if _(_filters).isEmpty()
    _filters[0]
  


  # Change Filter
  # ----------------------------------------------------------------------
  all: => @filtered.resetFilters()

  filterBySource: (source)=>
    @filtered.resetFilters()
    @filtered.filterBy( source, source:source ) unless source=='all'
    @handleUpdates()
  
  
  # Update Models (including focus)
  # ----------------------------------------------------------------------
  updateSingleSource: (source, models_data=[])=>
    # resets the collection - scoped to single source
    _(models_data).forEach (data) -> data.source=source
    only_models   = @where(source:source)
    except_models = @without(only_models...)
    @remove(except_models, {silent:true})
    @reset(models_data)
    @add(except_models, {silent:true})
    @filtered.refilter()
    @throttledHandleUpdates()
  
  handleUpdates: =>
    @all() unless @filtered.length
    @updateFocus()
    
  updateFocus: (optional_model)=>
    return unless @filtered.length
    @filtered.where(focus:true).forEach (m)-> m.set(focus:false)
    filtered_optional_model = optional_model && @filtered.findWhere(id:optional_model.id)
    focused = filtered_optional_model || @filtered.first()
    focused.set(focus:true)
    @trigger('filtered:updated')
  
  moveFocus: (up_down)=>
    direction     = if up_down=='up' then -1 else 1
    current_index = @filtered.indexOf @currentFocus()
    update_index  = current_index + direction
    update_index  = _.max([0, update_index])
    update_index  = _.min([update_index, @filtered.length-1])
    @updateFocus(@filtered.at(update_index))
    
  
  # Configuration
  # ----------------------------------------------------------------------
  comparator: (a,b)->
    [a, b] = [a.get('score'), b.get('score')]
    if a > b then return  -1
    if a < b then 1 else 0
  
  toJSON: =>
    @filtered.toJSON() #schema in model