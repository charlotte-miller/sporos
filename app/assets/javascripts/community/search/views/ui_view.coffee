class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onFocus'
    'click  .search-button' : 'onIcon'
    'submit .search-form'   : 'onSubmit'
    'keydown .text'         : 'onInputKey'
    'keyup   .text'         : 'onInputKey'
    
  
  initialize: =>
    @sources_collection = CStone.Community.Search.sources
    @dropdown = new CStone.Community.Search.Views.Suggestions
      collection: CStone.Community.Search.results
      context_selector: "##{@el.id}"
      sources_collection: @sources_collection
      parent_ui: @
      
    @bindTo @dropdown.collection, 'filtered:updated', 'updateHint'
  
  onFocus: (e)=>
    e.preventDefault()
    @dropdown.show()
    
  onIcon: (e)=>
    e.preventDefault()
    if @dropdown.isVisible
      @dropdown.hide()
      @$('.submit').blur()
      @clearSearch()
    else
      @$('.text').focus() #triggers @dropdown.show()
    
  onSubmit: (e)->
    e.preventDefault()
    # select focused result and hide
    
  onInputKey: (e)=>
    $target = $(e.target)
    specialKeyCodeMap =
      9 : 'tab',
      27: 'esc',
      39: 'right',
      13: 'enter',
      38: 'up',
      40: 'down'
         
    # keydown allows preventDefault()
    if e.type=='keydown' && specialKeyCodeMap[e.which]
      e.preventDefault()
      switch specialKeyCodeMap[e.which]
        when 'up'
          @dropdown.collection.moveFocus('up')
        when 'down'
          @dropdown.collection.moveFocus('down')
        when 'right'
          $target = $(e.target)
          @selectFocused($target)
        when 'tab'
          @selectFocused($target)
        when 'enter'
          @selectFocused($target, 'submit')
        when 'esc'
          @dropdown.hide()
          @$('.text').blur()
          @clearSearch()

    # keyup finishes updating the input (allow default)
    if e.type=='keyup' && !specialKeyCodeMap[e.which]
      backspace_keys = [8,91,93] #covers backspace and command backspace
      if _(backspace_keys).include(e.which)
        return @clearSearch() unless e.target.value.length && $target.isCursorAtEnd()
      @submitSearch e.target.value
  
  submitSearch: (query)=>
    if @current_search != query
      @current_search = query
      @sources_collection.search query
  
  updateHint: =>
    @$('.search-hint').val(@currentHint())
    
  clearSearch: =>
    @$('.search-hint').val('')
    unless @$('.text').val()
      @dropdown.collection.reset()
      @dropdown.collection.trigger('reset:clear_all')
  
  currentHint: (original_capitalization=false)=>
    focused =  @dropdown.collection.currentFocus()
    case_indiferent_matcher = ///^#{@current_search}///i
    if focused && case_indiferent_matcher.test focused.get('payload')
      payload = focused.get('payload')
      hint = payload.replace case_indiferent_matcher, @current_search
      if original_capitalization then payload else hint
    else
      ''

  selectFocused: ($target, submit=false)=>
    cap_hint = @currentHint('original_capitalization')
    @current_search = cap_hint
    $target.val cap_hint
    @updateHint()
    $target.putCursorAtEnd()
    if submit
      @dropdown.collection.currentFocus().open()
    else
      @submitSearch @currentHint()
   