#= require admin/templates/download_uploaded_file
#= require admin/templates/upload_uploaded_file

$ ->
  if $('#upload-photo').length
    $(document).on 'drop dragover', (e)-> e.preventDefault() #prevent's browser from just opening the file
    
    url = '/admin/uploaded_files'
    url += "?post[id]=#{post_id}" if post_id = $('#post_id').val()
    $.getJSON url, (data)->
      template = HandlebarsTemplates.download_uploaded_file(data)
      $('#dropzone-file-manager').append(template)
    
    $('#upload-photo').fileupload
      # url: '/admin/uploaded_files.json'
      limitConcurrentUploads: 3
      dataType: 'json'
      dropZone: $('#dropzone')
      paramName: 'uploaded_file[image]'
      autoUpload: true
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i #/(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
      maxNumberOfFiles: 10
      filesContainer: '#dropzone-file-manager'
      uploadTemplate:   HandlebarsTemplates.upload_uploaded_file
      downloadTemplate: HandlebarsTemplates.download_uploaded_file
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
