#= require community/news
#= require community/search
#= require community/posts/all

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
    # poster: "/assets/background_video_start.jpg" # handled with CSS
  ,
    posterType:'jpg'
    autoplay:false
  ).data('vide').getVideoObject()

  $(video_element).bind 'loadeddata', ->
    @play()
    $main_header.css({background:'none'})
    $(@).unbind 'loadeddata'


  $('#main-page a').not('.ministry, .photo-gallery, #photo-stack a, #times-and-locations a').click (e)->
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

  $('#times-and-locations').click (e)->
    e.preventDefault()
    $('#times-and-locations-body').toggleClass('active')
    if $('#times-and-locations-body.active').length
      col_sm_min = 768
      container  = $('#main-page')
      scroll_to  = if container.width() < col_sm_min then '#times-and-locations' else '#main-body'

      $(scroll_to).smoothScroll 500, CStone.Animation.layoutTransition.easing,
        container: container
