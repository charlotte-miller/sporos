class CStone.Community.Search.Views.UI extends CStone.Shared.Backbone.ExtendedView

  # events:
  #   'focus  .text'          : 'onInputFocus'
  #   'click  .search-button' : 'onIconClick'
  #   'submit .search-form'   : 'onSubmit'
  #   'keydown  .text'        : 'onInputKey'
  #   'keypress .text'        : 'onInputKey'
  #   'cut      .text'        : 'onInputKey'
  #   'paste    .text'        : 'onInputKey'

  # modelEvents: (active=false)=>
  #   if active
  #     @listenTo @session, 'change:current_search',    @thenUpdateText
  #     @listenTo @session, 'change:current_hint',      @thenUpdateHint
  #     @listenTo @session, 'change:hint_visible',      @thenUpdateHint
  #     @listenTo @session, 'change:dropdown_visible',  @thenToggleDropdown
  #     @listenTo @session, 'change:dropdown_visible',  @thenScrollToMainUI
  #   else
  #     @stopListening @session

  initialize: =>
    # @session = CStone.Community.Search.session
    @session.on 'change:active_ui', @onUIActivationChange
    _.defer( @onInputFocus ) if @$('.text').is(":focus") #already focused

  onUIActivationChange: (e)=>
    active = @ui_name == @session.get('active_ui')
    @modelEvents(active)

  # React to DOM - Change Models
  # ----------------------------------------------------------------------
  # onInputFocus: (e)=>
  #   e.preventDefault() if e
  #   @session.set active_ui: @ui_name #triggers listeners - must be first
  #   @session.set dropdown_visible:true
  #
  # onIconClick: (e)=>
  #   e.preventDefault()
  #   @session.set active_ui: @ui_name #triggers listeners - must be first
  #   @session.toggle('dropdown_visible')
  #
  # onSubmit: (e)->
  #   e.preventDefault()
  #   @session.acceptHint()
  #   @session.openFocused()
  #
  # onInputKey: (e)=>
  #   $target = $(e.target)
  #   key_code = e.which || e.keyCode
  #   specialKeyCodeMap =
  #     9 : 'tab',
  #     27: 'esc',
  #     39: 'right',
  #     13: 'enter',
  #     38: 'up',
  #     40: 'down'
  #
  #   # keydown allows preventDefault()
  #   if e.type=='keydown' && specialKeyCodeMap[key_code]
  #     switch specialKeyCodeMap[e.which]
  #       when 'up'
  #         e.preventDefault()
  #         @session.moveFocus('up')
  #       when 'down'
  #         e.preventDefault()
  #         @session.moveFocus('down')
  #       when 'right'
  #         if $target.isCursorAtEnd()
  #           e.preventDefault()
  #           @session.acceptHint()
  #       when 'tab'
  #         e.preventDefault()
  #         if $target.isCursorAtEnd()
  #           @session.acceptHint()
  #       when 'enter'
  #         e.preventDefault()
  #         @session.acceptHint()
  #         @session.openFocused()
  #       when 'esc'
  #         e.preventDefault()
  #         @session.set(dropdown_visible:false)
  #
  #   if !specialKeyCodeMap[key_code]
  #     _.defer =>
  #       backspace_keys = [8,91,93] #covers backspace and command backspace
  #       if _(backspace_keys).include(key_code) || e.type=='cut'
  #         @session.set(hint_visible:false) unless e.target.value.length && $target.isCursorAtEnd()
  #       @session.set( current_search: e.target.value )
  #
  #

  # React to Models - Change DOM
  # ----------------------------------------------------------------------

  thenOpenDropdown: =>
    @_createDropdown()
    @$el.addClass('search-focused')
    @session.set(current_search:$('.text').val())
    @$('.text').focus()

  thenCloseDropdown: =>
    @_destroyDropdown()
    @$el.removeClass('search-focused')
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

  thenScrollToMainUI: =>
    return unless @ui_name=='main' && @session.get('dropdown_visible')

    col_sm_min = 768
    container  = $('#main-page')
    scroll_to  = if container.width() < col_sm_min then '#global-search' else '#main-header'

    $(scroll_to).smoothScroll CStone.Animation.layoutTransition.duration, CStone.Animation.layoutTransition.easing,
      container: container
      offset:    -100 #offset mobile address-bars

  # Internal
  # ----------------------------------------------------------------------
  _createDropdown: =>
    @dropdown = new CStone.Community.Search.Views.Suggestions
      session: @session
      parent_view: @
    @$('.search').append(@dropdown.el)
    @dropdown.render()

  _destroyDropdown: =>
    @dropdown.remove()
    @dropdown = null
