# ===========================================================
# * jquery-simple-text-rotator.js v1
# * ===========================================================
# * Copyright 2013 Pete Rojwongsuriya.
# * http://www.thepetedesign.com
# *
# * A very simple and light weight jQuery plugin that 
# * allows you to rotate multiple text without changing 
# * the layout
# * https://github.com/peachananr/simple-text-rotator
# *
# * ========================================================== 
(($) ->
  defaults =
    animation: "dissolve"
    separator: ","
    speed: 2000

  $.fx.step.textShadowBlur = (fx) ->
    $(fx.elem).prop("textShadowBlur", fx.now).css textShadow: "0 0 " + Math.floor(fx.now) + "px black"
    return

  $.fn.textrotator = (options) ->
    settings = $.extend({}, defaults, options)
    @each ->
      el = $(this)
      array = []
      $.each el.text().split(settings.separator), (key, value) ->
        array.push value
        return

      el.text array[0]
      
      # animation option
      rotate = ->
        el.html el.find(".back").html()  if el.find(".back").length > 0
        initial = el.text()
        index = $.inArray(initial, array)
        index = -1  if (index + 1) is array.length
        el.html ""
        $("<span class='front'>" + initial + "</span>").appendTo el
        $("<span class='back'>" + array[index + 1] + "</span>").appendTo el
        el.wrapInner("<span class='rotating' />").find(".rotating").hide().addClass("flip up").show().css
          "-webkit-transform": " rotateX(-180deg)"
          "-moz-transform": " rotateX(-180deg)"
          "-o-transform": " rotateX(-180deg)"
          transform: " rotateX(-180deg)"

        settings.callback() if settings.callback?

      interval = setInterval rotate, settings.speed
      return interval #for future clearInterval(interval)


  return
)(window.jQuery)