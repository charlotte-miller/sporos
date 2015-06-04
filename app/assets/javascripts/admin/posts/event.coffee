#= require admin/templates/event_poster

$ ->
  $('.to-nowhere').click (e)-> e.preventDefault()
  
  # Date Picker
  if $('.pick-a-date, pick-a-date-w-clear').length
    min_date = new Date
    max_date = (time = $('#post_event_time').val()) && new Date(time)
    $('.pick-a-date').pickadate(clear:false,           min:min_date )
    $('.pick-a-date-w-clear').pickadate(clear:'Reset', min:min_date, max:max_date )
    $('.trigger-pick-a-date').click (e)->
      e.preventDefault()
      e.stopPropagation()
      if $(e.target).parents('.input-group').find('.form-control').hasClass('pick-a-date')
        $('.pick-a-date').pickadate('picker').open()
      else
        $('.pick-a-date-w-clear').pickadate('picker').open()

  # Time Picker
  if $('.pick-a-time').length
    $('.pick-a-time').pickatime(clear:false)
    $('.trigger-pick-a-time').click (e)->
      e.preventDefault()
      e.stopPropagation()
      $('.pick-a-time').pickatime('picker').open()
      
  
  advanced = $('#advanced-features')
  $('.panel-heading', advanced).click ->
    $('#advanced-drawer', advanced).toggleClass('closed')
    

  if $('#upload-event-poster').length
    $(document).on 'drop dragover', (e)-> e.preventDefault() #prevent's browser from just opening the file
    
    if post_id = $('#post_public_id').val()
      $.getJSON "/admin/posts/#{post_id}", (data)->
        template_data = {url:data.poster_url, thumbnail_url:data.poster_url}
        template = HandlebarsTemplates.event_poster(template_data)
        $('#dropzone-file-manager').append(template)
    
    $('#upload-event-poster').fileupload
      dropZone: $('#dropzone')
      autoUpload: false
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
      filesContainer: '#dropzone-file-manager'
      uploadTemplate:   HandlebarsTemplates.event_poster
      prependFiles: true
      singleFileUploads:true
      replaceFileInput:false
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
      change: -> $('#dropzone-file-manager').html('')