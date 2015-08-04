$ ->
  if $('#external-url-field').length
    loadUrlPreviewRunning = false
    loadUrlPreview = (external_url)->
      return if loadUrlPreviewRunning
      loadUrlPreviewRunning = true
      unless external_url.length
        loadUrlPreviewRunning = false
        $('#external-url-details').removeClass('populated')
        _.delay ->
          $('#post_title').val('')
          $('#post_description').val('')
          $('#link-poster').html('')
          $('#all_image_options').html('')
          $('#link-poster').imagepicker()
        , 100
        return

      $('#instrutions').addClass('loading')
      $('#external-url-field, #post-form-submit').prop('disabled', true)

      createImagePickerFrom = (images)->
        image_urls = _(images).map (i)-> i.src
        image_select_options = _(image_urls).map (url)->
          $("<option value='#{url}' data-img-src='#{url}'>#{url}</option>")

        all_image_options = _(image_urls).map (url)->
          $("<input type='hidden' value='#{url}' name='post[display_options][poster_alternatives][]'/>")

        $('#all_image_options').html(all_image_options)
        $('#link-poster').html(image_select_options)
        $('#link-poster').imagepicker()

      promise = $.getJSON "/admin/posts/link_preview?url=#{external_url}"
      promise.done (preview)->
        $('#post_title').val(preview.title)
        $('#post_description').val(preview.description)
        createImagePickerFrom(preview.images)
        autosize.update $('#post_description')
        $('#external-url-details').addClass('populated')
      promise.fail (failure)->
        $('#external-url-details').removeClass('populated')
        _.delay ->
          $('#post_title').val('')
          $('#post_description').val('')
          $('#link-poster').html('')
          $('#all_image_options').html('')
          $('#link-poster').imagepicker()
        , 100
      promise.always ->
        loadUrlPreviewRunning = false
        $('#external-url-field, #post-form-submit').prop('disabled', false)
        $('#instrutions').removeClass('loading')


    if $('#link-poster option').length
      $('#link-poster').imagepicker()

    $('#external-url-field').on 'paste', ->
      _.defer =>
        loadUrlPreview $(@).val()


    $('#external-url-field').on 'change', (e)->
      loadUrlPreview $(@).val()

    $('#external-url-field').click ->
      @.setSelectionRange(0, @.value.length)

    $('#external-url-field').focus()

