CStone.Base.Pages.init('/library', ['/'])

$ ->
  CStone.Shared.logger.info('Library Content Page Initialized')

  $('#page a').click (e)->
    e.preventDefault()
    CStone.Base.Pages.layout.loadPage $(@).prop('href')

