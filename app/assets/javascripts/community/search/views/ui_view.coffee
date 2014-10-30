class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onInputFocus'
    'click  .search-button' : 'onIconClick'
    'submit .search-form'   : 'onSubmit'
    'keydown .text'         : 'onInputKey'
    'keyup   .text'         : 'onInputKey'
    
  modelEvents: =>
    @listenTo @session, 'change:current_search',    '_updateText'
    @listenTo @session, 'change:current_hint',      '_updateHint'
    @listenTo @session, 'change:hint_visible',      '_updateHint'
    @listenTo @session, 'change:dropdown_visible',  '_toggleDropdown'
  
  initialize: =>
    @session = CStone.Community.Search.session
    @session.set current_search: @$('.text').val()
    
    @sources_collection = @session.get('sources')
    @dropdown = new CStone.Community.Search.Views.Suggestions
      collection: @session.get('results')
      context_selector: "##{@el.id}"
      sources_collection: @sources_collection
      parent_view: @

    @modelEvents()
          
  
  # 1) Clean this up into declarative private functions - Unwind any dependencies
  # 2) use _functions for event listeners (commit here)
  # 3) refactor @dropdown.render() into _open / __closeDropdown

    
  clearSearch: =>
    @_clearHint() # in model
    @_clearSearch unless @$('.text').val()
        
   
  
  # React to Models - Change DOM
  # ----------------------------------------------------------------------
  
  _openDropdown: =>
    @dropdown.show()
    @$('.text').focus()

  _closeDropdown: =>
    @dropdown.hide()
    @$('.submit, .text').blur()

  _toggleDropdown: =>
    if @session.get('dropdown_visible')
      @_openDropdown()
    else
      @_closeDropdown()
  
  _updateText: =>
    return if @$('.text').val() == @session.get('current_search')
    @$('.text').val(@session.get('current_search'))
    @$('.text').putCursorAtEnd()
  
  _updateHint: =>
    if @session.get('hint_visible')
      @$('.search-hint').val(@session.get('current_hint'))
    else
      @$('.search-hint').val('')


  # React to DOM - Change Models
  # ----------------------------------------------------------------------
  onInputFocus: (e)=>
    e.preventDefault()
    @session.set dropdown_visible:true
  
  onIconClick: (e)=>
    e.preventDefault()
    @session.toggle('dropdown_visible')
  
  onSubmit: (e)->
    e.preventDefault()
    @session.acceptHint()
    @session.openFocused()

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
          @session.moveFocus('up')
        when 'down'
          @session.moveFocus('down')
        when 'right'
          @session.acceptHint()
        when 'tab'
          @session.acceptHint()
        when 'enter'
          @session.acceptHint()
          @session.openFocused()
        when 'esc'
          @_closeDropdown()

    # keyup finishes updating the input (allow default)
    if e.type=='keyup' && !specialKeyCodeMap[e.which]
      backspace_keys = [8,91,93] #covers backspace and command backspace
      if _(backspace_keys).include(e.which)
        return @session.set(hint_visible:false) unless e.target.value.length && $target.isCursorAtEnd()
      @_submitSearch e.target.value
  
  
  _submitSearch: (query)=>
    @session.set current_search: query