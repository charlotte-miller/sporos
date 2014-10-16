class CStone.Community.Search.Models.Result extends Backbone.Model
  
  defaults:
    score:0
  
  initialize: =>
    _(['id','source']).forEach (requirement)=>
      throw Error("A Result MUST have a #{requirement}") unless @get(requirement)
  
  toJSON: =>
    id: @get('id')
    source:  @get('source')
    payload: @get('payload')
    destination: @get('destination')
    focusClass: if @get('focus') then 'active' else ''
  
  open: =>
    window.location= @get('destination')
    #or something fancier