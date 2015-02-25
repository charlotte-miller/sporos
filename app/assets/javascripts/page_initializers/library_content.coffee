CStone.Community.Pages.init('/library', ['/'])

$ ->
  CStone.Shared.logger.info('Library Content Page Initialized')
  
  $('#page a').click (e)->
    e.preventDefault()
    CStone.Community.Pages.layout.loadPage $(@).prop('href')
  