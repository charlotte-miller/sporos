CStone.Base.Pages.init('/', ['/library'])

$ ->
  CStone.Shared.logger.info('Community Content Page Initialized')

  $('#page a').click (e)->
    e.preventDefault()
    CStone.Base.Pages.layout.loadPage $(@).prop('href')
