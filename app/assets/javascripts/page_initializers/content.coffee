CStone.Community.Pages.init('/library', ['/'])

$ ->
  CStone.Shared.logger.info('Content Page Initialized')
  
  $backlink_tab = $('#backlinks')
  if $backlink_tab.length

    $('a', $backlink_tab).click (e)->
      e.preventDefault()
      CStone.Community.Pages.layout.loadPage $(@).prop('href')

    # Shrink after 2 seconds
    setTimeout (-> $backlink_tab.removeClass('full')), 2000