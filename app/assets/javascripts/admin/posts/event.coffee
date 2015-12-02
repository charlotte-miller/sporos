#= require admin/templates/event_poster

$ ->
  $('.to-nowhere').click (e)-> e.preventDefault()

  $('.well.checkbox').click (e)->
    e.preventDefault()
    $checkbox = $('#comm-arts-request-design-checkbox')
    $checkbox.prop('checked', !$checkbox.prop('checked'))
    $checkbox.trigger('change')

  $('#comm-arts-request-design-checkbox').on 'change', ->
    if $(@).prop('checked')
      $('#comm_arts_design_questions').addClass 'open-drawer'
    else
      $('#comm_arts_design_questions').removeClass 'open-drawer'

  $('#comm-arts-request-design-checkbox').trigger('change')

  # Date Picker
  if $('#event-pickadate, #expired-at-pickadate, #comm-arts-due-pickadate').length
    min_date = new Date
    max_date = (time = $('#post_event_time').val()) && new Date(time)
    $('#event-pickadate').pickadate(container: '.container', clear:false, min:min_date )
    $('#expired-at-pickadate').pickadate(container: '.container', clear:'Reset', min:min_date, max:max_date )
    $('#comm-arts-due-pickadate').pickadate(container: '.container', clear:'Reset', min:min_date, max:max_date )
    $('.trigger-pick-a-date').click (e)->
      e.preventDefault()
      e.stopPropagation()
      switch $(e.target).parents('.input-group').find('.form-control').prop('id')
        when 'event-pickadate' then $('#event-pickadate').pickadate('picker').open()
        when 'expired-at-pickadate' then $('#expired-at-pickadate').pickadate('picker').open()
        when 'comm-arts-due-pickadate' then $('#comm-arts-due-pickadate').pickadate('picker').open()

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
    $(document).on 'dragover drop', (e)->
      unless e.target.id == 'upload-event-poster'
        e.preventDefault() #prevent's browser from just opening the file

    if post_id = $('#post_public_id').val()
      $.getJSON "/admin/posts/#{post_id}", (data)->
        template_data = {url:data.poster_url, thumbnail_url:data.poster_url}
        template = HandlebarsTemplates.event_poster(template_data)
        $('#dropzone-file-manager').append(template)

    $('#upload-event-poster').bind 'dragover',   -> $('#dropzone').addClass 'active'
    $('#upload-event-poster').bind 'dragleave',  -> $('#dropzone').removeClass 'active'
    $('#upload-event-poster').bind 'mouseenter', -> $('#dropzone').addClass 'active'
    $('#upload-event-poster').bind 'mouseleave', -> $('#dropzone').removeClass 'active'
    $('#upload-event-poster').bind 'mouseleave', -> $('#dropzone').removeClass 'active'

    $('#upload-event-poster').fileupload
      dropZone: false
      autoUpload: false
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
      filesContainer: '#dropzone-file-manager'
      uploadTemplate:   HandlebarsTemplates.event_poster
      prependFiles: true
      singleFileUploads:true
      replaceFileInput:false
      previewMaxHeight:180
      previewMinHeight:179
      previewMaxWidth:300
      change: -> $('#dropzone-file-manager').html('')
