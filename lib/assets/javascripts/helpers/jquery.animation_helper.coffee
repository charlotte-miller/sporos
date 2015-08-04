$ ->
  jQuery.fn.slideFadeToggle = (speed, easing, callback) ->
    @animate
      opacity: "toggle"
      height: "toggle"
    , speed, easing, callback

  jQuery.fn.slideFadeHide = (speed, easing, callback) ->
    @animate
      opacity: 0
      height: "0px"
    , speed, easing, callback
    return

  jQuery.fn.slideFadeShow = (speed, easing, callback) ->
    target_height = @height()
    @css({display:'block', height:'0px',opacity:0,visibility:'visible'})
    @animate
      opacity: 1
      height: "#{target_height }px"
    , speed, easing, callback

# possible firefox fail
  jQuery.fn.smoothScroll = (speed, easing, options={}, callback) ->
    target = $(@)
    if target.length
      container = options.container || $("html,body")
      relative_scroll_top = target.offset().top - container.offset().top + container.scrollTop()
      container.animate
        scrollTop: relative_scroll_top + (options.offset || 0)
      , speed, easing, callback
