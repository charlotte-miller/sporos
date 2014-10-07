# class CStone.Community.Search.UI
#   constructor: (input_selector, data_sources=[]) ->
#     easing   = CStone.Animation.layoutTransition.easing
#     duration = CStone.Animation.layoutTransition.duration
#
#     $ =>
#       @$typeahead = $(input_selector).typeahead
#         hint:true
#         minLength: 1
#         highlight: true,
#         data_sources
#
#       $mainHeader = $('#main-header')
#
#       @$typeahead.on 'typeahead:opened', ->
#         $mainHeader.addClass('search-focused')
#         $mainHeader.velocity 'scroll',
#           container: $('#main-page')
#           easing: easing
#           duration: duration
#
#       @$typeahead.on 'typeahead:closed', ->
#         $mainHeader.removeClass('search-focused')
#
#       $('.suggestion-nav-source').click ->
#         if $('.caret:visible', @).length > 0
#           $(@).closest('.suggestions-nav').toggleClass('expanded')
