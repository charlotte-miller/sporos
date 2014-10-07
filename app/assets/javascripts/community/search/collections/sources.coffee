class CStone.Community.Search.Collections.Sources extends Backbone.Collection
  PRESENTATION_ORDER = 'ministry event sermon music page announcement question'.split(' ')
  
  ###
    options[:only]
    options[:except]
  ###
  search: (query, options={})=>
    @models.forEach (source)-> source.search(query)

  comparator: (a,b)->
    [a,b] = [a,b].map (source)-> PRESENTATION_ORDER.indexOf source.get('name')
    if a < b then return  -1
    if a > b then 1 else 0
    
  updateFocus: (optional_model)=>
    return unless @length
    current_focus = @findWhere(focus:true)
    current_focus.set(focus:false) if current_focus
    optional_model.set(focus:true) if optional_model