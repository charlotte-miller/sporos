class CStone.Community.Search.Models.Session extends Backbone.RelationalModel
  
  initialize: =>
    @on 'change:current_search',   @_searchSourcesForCurrentSearch
    @on 'change:current_search',   @_storeSearchHistory
    @on 'change:dropdown_visible', @_hideHintWhenHidingDropdown
    @listenTo @get('results'), 'filtered:updated', @_updateCurrentHint
  
  defaults:
    dropdown_visible:false
    hint_visible:false
    current_search:''
    current_hint:''
    current_hint_w_original_capitalization:''
    
  relations: _([
    {
      type:            'HasMany'
      key:             'results'
      relatedModel:    'CStone.Community.Search.Models.Result'
      collectionType:  'CStone.Community.Search.Collections.Results'
    },
    {
      type:            'HasMany'
      key:             'sources'
      relatedModel:    'CStone.Community.Search.Models.AbstractSource'
      collectionType:  'CStone.Community.Search.Collections.Sources'
    },
    # {
    #   type:            'HasOne'
    #   key:             'search_history'
    #   relatedModel:    'CStone.Community.Search.Models.SearchHistory'
    # }
  ]).map (relation)-> _(relation).extend(reverseRelation: {key:'session', type:'HasOne'})

  # Public Helpers
  # ----------------------------------------------------------------------
  
  searchState: =>
    is_searching = !!@get('current_search')
    return 'pre-search'   unless is_searching
    return 'searching'    if is_searching && @get('results').length
    return 'no-results'   if is_searching
  
  acceptHint: =>
    @set
      current_search: @get('current_hint_w_original_capitalization')
      current_hint:   @get('current_hint_w_original_capitalization')
  
  # toggle dropdown_visible, hint_visible, etc.
  toggle: (flag)=>
    val = @get(flag)
    throw new Error('Cannot Toggle a non-boolean value') unless _(val).isBoolean()
    @set(flag, !val)

  openFocused: =>
    @get('results').currentFocus().open()
  
  moveFocus: (up_down)=>
    @get('results').moveFocus(up_down)
  
  # Internal
  # ----------------------------------------------------------------------

  _searchSourcesForCurrentSearch: =>
    query = @get('current_search')
    return if ///^#{@previous('current_search')||''}$///i.test query
    if query
      @get('sources').search(query)
    else
      @get('results').reset()
      @get('results').trigger('reset:clear_all')

  _hideHintWhenHidingDropdown: =>
    @set(hint_visible:false) unless @get('dropdown_visible')
  
  _updateCurrentHint: =>
    current_search = @get('current_search')
    focused =  @get('results').currentFocus() && @get('results').currentFocus().get('payload')
    case_indiferent_matcher = ///^#{current_search}///i
    if focused && case_indiferent_matcher.test focused
      hint = focused.replace case_indiferent_matcher, current_search
      @set(current_hint: hint, current_hint_w_original_capitalization: focused, hint_visible:true)
    else
      @set(current_hint: '', current_hint_w_original_capitalization: '', hint_visible:false)
      
  _storeSearchHistory:=>
    # add @get('current_search') to a seperate SearchHistory object
    # collaps typing into the 'final' product
    # store the selected (opened) result
    # store dead-ends (zero results) and the next thing they search/select

CStone.Community.Search.Models.Session.setup()