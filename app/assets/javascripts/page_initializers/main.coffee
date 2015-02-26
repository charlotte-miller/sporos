#= require community/news
#= require community/search

CStone.Base.Pages.init('/', ['/library'])
CStone.Community.News.init()
CStone.Community.Search.init()

$ ->
  CStone.Shared.logger.info('Main Page Initialized')
  
  $main_header  = $('#main-header')
  video_element = $main_header.vide(
    mp4:    "http://vodkabears.github.io/vide/video/ocean.mp4"
    webm:   "http://vodkabears.github.io/vide/video/ocean.webm"
    ogv:    "http://vodkabears.github.io/vide/video/ocean.ogv"
    poster: "/assets/background_video_start.jpg"
  ,
    posterType:'jpg'
    autoplay:false
  ).data('vide').getVideoObject()

  $(video_element).bind 'loadeddata', ->
    @play()
    $main_header.css({background:'none'})
    $(@).unbind 'loadeddata'


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