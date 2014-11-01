class CStone.Community.Search.Views.UI extends Backbone.View

  events:
    'focus  .text'          : 'onInputFocus'
    'click  .search-button' : 'onIconClick'
    'submit .search-form'   : 'onSubmit'
    'keydown  .text'        : 'onInputKey'
    'keypress .text'        : 'onInputKey'
    'cut      .text'        : 'onInputKey'
    'paste    .text'        : 'onInputKey'
    
  modelEvents: =>
    @listenTo @session, 'change:current_search',    @thenUpdateText
    @listenTo @session, 'change:current_hint',      @thenUpdateHint
    @listenTo @session, 'change:hint_visible',      @thenUpdateHint
    @listenTo @session, 'change:dropdown_visible',  @thenToggleDropdown
  
  initialize: =>
    @session = CStone.Community.Search.session
    @dropdown = new CStone.Community.Search.Views.Suggestions
      context_selector: "##{@el.id}"
      collection: @session.get('results')
      sources_collection: @session.get('sources')
      parent_view: @

    @modelEvents()
    @session.set current_search: @$('.text').val()
  
  # 1) Clean this up into declarative private functions - Unwind any dependencies
  # 2) use _functions for event listeners (commit here)
  # 3) refactor @dropdown.render() into _open / _thenCloseDropdown

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
    key_code = e.which || e.keyCode
    specialKeyCodeMap =
      9 : 'tab',
      27: 'esc',
      39: 'right',
      13: 'enter',
      38: 'up',
      40: 'down'
    
    # keydown allows preventDefault()
    if e.type=='keydown' && specialKeyCodeMap[key_code]
      switch specialKeyCodeMap[e.which]
        when 'up'
          e.preventDefault()
          @session.moveFocus('up')
        when 'down'
          e.preventDefault()
          @session.moveFocus('down')
        when 'right'
          if $target.isCursorAtEnd()
            e.preventDefault()
            @session.acceptHint()
        when 'tab'
          e.preventDefault()
          if $target.isCursorAtEnd()
            @session.acceptHint()
        when 'enter'
          e.preventDefault()
          @session.acceptHint()
          @session.openFocused()
        when 'esc'
          e.preventDefault()
          @session.set(dropdown_visible:false)

    if !specialKeyCodeMap[key_code]
      _.defer =>
        backspace_keys = [8,91,93] #covers backspace and command backspace
        if _(backspace_keys).include(key_code) || e.type=='cut'
          @session.set(hint_visible:false) unless e.target.value.length && $target.isCursorAtEnd()
        @session.set( current_search: e.target.value )


  
  # React to Models - Change DOM
  # ----------------------------------------------------------------------
  
  thenOpenDropdown: =>
    @dropdown.show()
    @$('.text').focus()

  thenCloseDropdown: =>
    @dropdown.hide()
    @$('.submit, .text').blur()

  thenToggleDropdown: =>
    if @session.get('dropdown_visible')
      @thenOpenDropdown()
    else
      @thenCloseDropdown()
  
  thenUpdateText: =>
    return if @$('.text').val() == @session.get('current_search')
    @$('.text').val(@session.get('current_search'))
    @$('.text').putCursorAtEnd()
  
  thenUpdateHint: =>
    if @session.get('hint_visible')
      @$('.search-hint').val(@session.get('current_hint'))
    else
      @$('.search-hint').val('')
