class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onFocus'       # _openDropdown
    'click  .search-button' : 'onIcon'        # toggleDropdown
    'submit .search-form'   : 'onSubmit'      # submitFocused
    'keydown .text'         : 'onInputKey'    # 
    'keyup   .text'         : 'onInputKey'    # 
    
  
  initialize: =>
    @session = CStone.Community.Search.session
    @session.set current_search: @$('.text').val()
    
    @sources_collection = @session.get('sources')
    @dropdown = new CStone.Community.Search.Views.Suggestions
      collection: @session.get('results')
      context_selector: "##{@el.id}"
      sources_collection: @sources_collection
      parent_view: @
      
    @bindTo @dropdown.collection, 'filtered:updated', 'updateHint'
  
  onFocus: (e)=>
    e.preventDefault()
    @_openDropdown()
    
  onIcon: (e)=>
    e.preventDefault()
    @_toggleDropdown()
    
  onSubmit: (e)->
    e.preventDefault()
    $target = $(e.target)
    @selectFocused($target, 'submit')
    
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
          @_closeDropdown()
          @$('.text').blur()
          @clearSearch()

    # keyup finishes updating the input (allow default)
    if e.type=='keyup' && !specialKeyCodeMap[e.which]
      backspace_keys = [8,91,93] #covers backspace and command backspace
      if _(backspace_keys).include(e.which)
        return @clearSearch() unless e.target.value.length && $target.isCursorAtEnd()
      @submitSearch e.target.value
  
  
  # 1) Clean this up into declarative private functions - Unwind any dependencies
  # 2) use _functions for event listeners (commit here)
  # 3) refactor @dropdown.render() into _open / __closeDropdown
  # 
  # __openDropdown
  # __closeDropdown
  # _toggleDropdown
  # _finishHintedSuggestion
  # _clearSuggestion
  # _clearInput
  # _openFocused
  
  
  submitSearch: (query)=>
    @session.set current_search: query
  
  updateHint: =>
    @$('.search-hint').val(@currentHint())
    
  clearSearch: =>
    @_clearHint()
    @_clearSearch unless @$('.text').val()

  
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
   
  # Internal DOM Functions
  # -------------------------
    
  _openDropdown: =>
    @dropdown.show()

  _closeDropdown: =>
    @dropdown.hide()

  _toggleDropdown: =>
    if @dropdown.isVisible
      @_closeDropdown()
      @$('.submit, .text').blur()
      @clearSearch()
    else
      @$('.text').focus() #triggers @_openDropdown()

  _clearHint: =>
    @$('.search-hint').val('')
  
  _finishHintedSuggestion: =>


  _clearSuggestion: =>


  _clearInput: =>


  _openFocused: =>


  # Internal Model Functions
  # -------------------------
  
  _clearSearch: =>
    @session.set current_search: ''

