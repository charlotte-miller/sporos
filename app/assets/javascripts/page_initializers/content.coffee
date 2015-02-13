CStone.Community.Pages.init()

$ ->
  CStone.Shared.logger.info('Content Page Initialized')
  
  $backlink_tab = $('#backlinks')
  if $backlink_tab.length
    
    # Eager-load on hover
    $('a', $backlink_tab).mouseenter (e)->
      url = $(@).prop('href')
      CStone.Community.Pages.layout.loadPage(url,{onlyPrefetch:true})
    
    $('a', $backlink_tab).click (e)->
      e.preventDefault()
      CStone.Community.Pages.layout.loadPage $(@).prop('href')
    
    # Shrink after 2 seconds
    setTimeout (-> $backlink_tab.removeClass('full')), 2000