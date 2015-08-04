CStone.Base.Pages.init('/library', ['/'])

$ ->
  $('#study-library').setupMediaItems ($details_scope)->
    $('.lessons a', $details_scope).click (e)->
      e.preventDefault()
      CStone.Base.Pages.layout.loadPage $(@).prop('href')
