$ ->
  CStone.Shared.logger.info('Auth Page Initialized')
  
  $main_header  = $('#auth-background')
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
