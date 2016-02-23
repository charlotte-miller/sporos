#= require blueimp-load-image/js/load-image.all.min
#= require blueimp-canvas-to-blob
#= require jquery-file-upload/js/jquery.iframe-transport
#= require jquery-file-upload/js/vendor/jquery.ui.widget
#= require jquery-file-upload/js/jquery.fileupload
#= require jquery-file-upload/js/jquery.fileupload-process
#= require jquery-file-upload/js/jquery.fileupload-image
#= require jquery-file-upload/js/jquery.fileupload-audio
#= require jquery-file-upload/js/jquery.fileupload-video
#= require jquery-file-upload/js/jquery.fileupload-validate
#  require jquery-file-upload/js/jquery.fileupload-ui

$ ->
  CStone.Shared.logger.info('Auth Page Initialized')

  $main_header  = $('#auth-background')
  video_element = $main_header.vide(
    mp4:    "http://assets.cornerstonesf.org/Blue-Bottle/MP4/Blue-Bottle.mp4" # "https://player.vimeo.com/external/144705298.hd.mp4?s=a65c31dcb9787fb34caf94ede0245263852fffc5&profile_id=113" #"http://vodkabears.github.io/vide/video/ocean.mp4"
    webm:   "http://assets.cornerstonesf.org/Blue-Bottle/WEBM/Blue-Bottle.webm" # "http://vodkabears.github.io/vide/video/ocean.webm"
    ogv:    "http://assets.cornerstonesf.org/Blue-Bottle/OGV/Blue-Bottle.ogv" # "http://vodkabears.github.io/vide/video/ocean.ogv"
    poster: "http://assets.cornerstonesf.org/Blue-Bottle/Snapshots/Blue-Bottle.jpg" # "/assets/background_video_start.jpg" # handled with CSS
  ,
    posterType:'jpg'
    autoplay:false
  ).data('vide').getVideoObject()

  $(video_element).bind 'loadeddata', ->
    @play()
    $main_header.css({background:'none'})
    $(@).unbind 'loadeddata'


  # =====================================
  # =            File Upload            =
  # =====================================

  progress_data = {visible:0, actual:0, img_ready:false}
  @handleProgress = (e, data, ceiling=359)->
    loader = document.getElementById('loader')
    border = document.getElementById('border')
    π = Math.PI
    progress_data.actual= parseInt(360 * (data.loaded / data.total), 10)

    # Animate to Value
    (draw = ->
      α = _([progress_data.visible += 1, ceiling]).min()
      r = α * π / 180
      x = Math.sin(r) * 125
      y = Math.cos(r) * -125
      mid = if α > 180 then 1 else 0
      anim = 'M 0 0 v -125 A 125 125 1 ' + mid + ' 1 ' + x + ' ' + y + ' z'
      loader.setAttribute 'd', anim
      border.setAttribute 'd', anim

      # Crude Animation
      setTimeout( draw, 20 ) unless α >= _([progress_data.actual, ceiling]).min()

      if α >= 360 && progress_data.img_ready
        $(".img-circle").attr("src", progress_data.img_ready )
        progress_data = {visible:0, actual:0, img_ready:false}
        α = 0
        r = α * π / 180
        x = Math.sin(r) * 125
        y = Math.cos(r) * -125
        mid = if α > 180 then 1 else 0
        anim = 'M 0 0 v -125 A 125 125 1 ' + mid + ' 1 ' + x + ' ' + y + ' z'
        loader.setAttribute 'd', anim
        border.setAttribute 'd', anim
    )()

  if $('#edit_user').length
    $(document).on 'drop dragover', (e)-> e.preventDefault() #prevent's browser from just opening the file

    $('#edit_user').fileupload
      limitConcurrentUploads: 3
      dataType: 'json'
      dropZone: $('#dropzone')
      paramName: 'only_profile_image'
      autoUpload: true
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i #/(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
      maxNumberOfFiles: 10
      filesContainer: '#dropzone-file-manager'
      prependFiles: true
      dragover: _.throttle(->
        dropZone = $('#dropzone')
        timeout = window.dropZoneTimeout
        if !timeout
          dropZone.addClass 'active'
        else
          clearTimeout timeout

        window.dropZoneTimeout = setTimeout((->
          window.dropZoneTimeout = null
          dropZone.removeClass 'active'
        ), 50)
      , 50)
      previewMaxHeight:180
      previewMinHeight:179
      previewMaxWidth:300
      disableImageResize:false
      imageMaxWidth:800
      imageMaxHeight:800
      # progressInterval:100
      progress: @handleProgress
      done: (e, data)=>
        new_src = data.result.url
        image = $("<img src='#{new_src}?#{+new Date()}'/>")
        .on "load", =>
          console.log('loaded')
          progress_data.img_ready = "#{new_src}?#{+new Date()}"
          @handleProgress({}, {loaded:1, total:1}, 360)
        .on "error", (e)->
          setTimeout ->
            cache_busted_url = image.attr('src').replace /\?\d*$/, "?#{+new Date}"
            image.attr('src', cache_busted_url)
          , 1000

