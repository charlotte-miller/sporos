#= require community/news
#= require community/search

CStone.Base.Pages.init('/', ['/library'])
CStone.Community.News.init()
CStone.Community.Search.init()

$ ->
  CStone.Shared.logger.info('Main Page Initialized')
  
  $('#main-page a').not('.ministry').click (e)->
    e.preventDefault()

    $('#headroom').removeClass('headroom--pinned')
    $('#headroom').addClass('headroom--unpinned')

    CStone.Base.Pages.layout.loadPage $(@).prop('href')
  
  $('#headroom').headroom
    offset : 800
    scroller: document.getElementById('main-page')
    onUnpin: -> CStone.Community.Search.session.set(dropdown_visible:false)
    tolerance:
      down:30
      up:100