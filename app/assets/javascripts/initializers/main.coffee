CStone.Community.News.init()
CStone.Community.Pages.init()
CStone.Community.Search.init()

$ ->
  $('#headroom').headroom
    offset : 800
    scroller: document.getElementById('main-page')
    tolerance:
      down:30
      up:100