CStone.Community.Pages.init()

$ ->
  CStone.Shared.logger.info('Content Page Initialized')
  
  $('.view-port-page.current a').click (e)->
    e.preventDefault()
    CStone.Community.Pages.layout.loadPage $(@).prop('href')
  
  $home_tab = $('#go_home')
  if $home_tab.length
    
    # Eager-load on hover
    $home_tab.mouseenter (e)->
      url = $(@).prop('href')
      CStone.Community.Pages.layout.loadPage(url,{onlyPrefetch:true})
    
    # Shrink after 2 seconds
    setTimeout (-> $home_tab.removeClass('full')), 2000