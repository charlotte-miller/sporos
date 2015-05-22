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

  
  # =====================================
  # =            File Upload            =
  # =====================================
  
  progress_data = {visible:0, actual:0, img_ready:false}
  @handleProgress = (e, data)->
    loader = document.getElementById('loader')
    border = document.getElementById('border')
    π = Math.PI
    progress_data.actual= parseInt(360 * (data.loaded / data.total), 10)
  
    # Animate to Value
    (draw = ->
      α = progress_data.visible += 1
      r = α * π / 180
      x = Math.sin(r) * 125
      y = Math.cos(r) * -125
      mid = if α > 180 then 1 else 0
      anim = 'M 0 0 v -125 A 125 125 1 ' + mid + ' 1 ' + x + ' ' + y + ' z'
      loader.setAttribute 'd', anim
      border.setAttribute 'd', anim
      
      # Crude Animation
      setTimeout( draw, 20 ) unless α >= _([progress_data.actual, 359]).min()
      
      if α >= 360
        $(".img-circle").attr("src", progress_data.img_ready )
        progress_data = {visible:0, actual:0, img_ready:false}
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
        
        $.ajax
          url: new_src
          type: 'GET'
          tryCount: 0
          retryLimit: 20
          success: (json) =>
            progress_data.img_ready = new_src
            @handleProgress({}, {loaded:1, total:1})
          
          error: (xhr, textStatus, errorThrown) ->
            if xhr.status % 400 < 100
              @tryCount++
              if @tryCount <= @retryLimit
                setTimeout =>
                  $.ajax @ #try again
                , 1000
      
    
  