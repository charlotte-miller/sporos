#= require admin/templates/download_uploaded_file
#= require admin/templates/upload_uploaded_file

$ ->
  if $('#upload-uploaded-file').length
    $(document).on 'drop dragover', (e)-> e.preventDefault() #prevent's browser from just opening the file
    
    # $('#upload-uploaded-file').attr('name','uploaded_file[file]')
    $('#upload-uploaded-file').fileupload
      # url: '/admin/uploaded_files.json'
      limitConcurrentUploads: 3
      dataType: 'json'
      dropZone: $('#dropzone')
      paramName: 'uploaded_file[file]'
      autoUpload: true
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i #/(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
      maxNumberOfFiles: 10
      filesContainer: '#dropzone'
      uploadTemplate:   HandlebarsTemplates.upload_uploaded_file
      downloadTemplate: HandlebarsTemplates.download_uploaded_file
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
