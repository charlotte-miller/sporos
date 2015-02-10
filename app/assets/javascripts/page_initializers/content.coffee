CStone.Community.Pages.init()

$ ->
  CStone.Shared.logger.info('Content Page Initialized')
  
  $('.view-port-page.current a').click (e)->
    e.preventDefault()
    CStone.Community.Pages.layout.loadPage $(@).prop('href')
  
  if $('#go_home.full').length
    setTimeout (-> $('#go_home.full').removeClass('full')), 2000