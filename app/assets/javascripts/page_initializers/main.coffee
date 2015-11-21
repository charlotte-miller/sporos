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
    mp4:    "https://player.vimeo.com/external/144705298.hd.mp4?s=a65c31dcb9787fb34caf94ede0245263852fffc5&profile_id=113" #"http://vodkabears.github.io/vide/video/ocean.mp4"
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


  $('#main-page a').not('.ministry, .photo-gallery, #photo-stack a, .evergreen-link a').click (e)->
    e.preventDefault()
    CStone.Base.Pages.layout.loadPage $(@).prop('href')

  CStone.Shared.ScrollSpy.addCallback (scroll)=>
    scroll_past = scroll > 500
    if scroll_past
      $('#main-footer').addClass('active')
      $('#doorbell-button').addClass('hide')

  CStone.Shared.ScrollSpy.addCallback (scroll)=>
    scroll_past = scroll < 500
    if scroll_past
      $('#main-footer').removeClass('active')
      $('#doorbell-button').removeClass('hide')


  $('#evergreen-links .evergreen-link').click (e)->
    e.preventDefault()
    target_id  = $(e.target).closest('a').data('drawer')
    current_id = $('.evergreen-body.active').attr('id')
    $('#evergreen-link-bodies .evergreen-body').removeClass('active')
    $( "##{target_id}" ).addClass('active') unless target_id == current_id

    if $('.evergreen-body.active').length
      col_sm_min = 768
      container  = $('#main-page')
      scroll_to  = if container.width() < col_sm_min then "##{target_id}-link" else '#main-body'

      $(scroll_to).smoothScroll 500, CStone.Animation.layoutTransition.easing,
        container: container

  $('#main-footer .feedback').click (e)->
    e.preventDefault()
    doorbell.show() if doorbell?
    $('#doorbell-attach-screenshot').prop('checked',true)