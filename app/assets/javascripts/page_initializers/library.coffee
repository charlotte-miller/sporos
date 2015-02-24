#= require page_initializers/content

$ ->
  $('#study-library').setupMediaItems ($details_scope)->
    $('.lessons a', $details_scope).click (e)->
      e.preventDefault()
      CStone.Community.Pages.layout.loadPage $(@).prop('href')