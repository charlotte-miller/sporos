#= require community/search/models/result

class CStone.Community.Search.Collections.Results extends CStone.Shared.Backbone.ExtendedCollection
  model: CStone.Community.Search.Models.Result
  
  initialize: =>
    # https://github.com/jmorrell/backbone-filtered-collection
    @filtered = new FilteredCollection(@)
    @filtered.grouped = -> @groupBy('source')
    @filtered.sources = -> @pluck('source')
    @updateFocus()
  
  grouped: => @filtered.grouped()
  sources: => @filtered.sources()
  all: => @filtered.resetFilters()
  allGrouped: => @groupBy('source')
  allSources: => @pluck('source')
  
  current_filter: =>
    _filters = @filtered.getFilters()
    return 'all' if _(_filters).isEmpty()
    _filters[0]
  
  filterBySource: (source)=>
    @filtered.resetFilters()
    @filtered.filterBy( source, source:source ) unless source=='all'
    @handleUpdates()
  
  updateSingleSource: (source, models_data=[])=>
    _(models_data).forEach (data) -> data.source=source
    only_models   = @where(source:source)
    except_models = @without(only_models...)
    @remove(except_models, {silent:true})
    @reset(models_data)
    @add(except_models, {silent:true})
    @filtered.refilter()
    @handleUpdates()
  
  handleUpdates: =>
    @all() unless @filtered.length
    @updateFocus()
    @trigger('filtered:updated')
    return @filtered
    
  updateFocus: (optional_model)=>
    return unless @filtered.length
    @where(focus:true).forEach (m)-> m.set(focus:false)
    focused = optional_model || @filtered.first()
    focused.set(focus:true)
        
  comparator: (a,b)->
    [a, b] = [a.get('score'), b.get('score')]
    if a > b then return  -1
    if a < b then 1 else 0
  
  toJSON: =>
    @filtered.toJSON() #schema in model