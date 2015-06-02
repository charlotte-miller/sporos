#= require admin/templates/download_uploaded_file
#= require admin/templates/upload_uploaded_file

$ ->
  if $('#upload-video').length
    $(document).on 'drop dragover', (e)-> e.preventDefault() #prevent's browser from just opening the file
    
    url = '/admin/uploaded_files'
    url += "?post[id]=#{post_id}" if post_id = $('#post_id').val()
    $.getJSON url, (data)->
      template = HandlebarsTemplates.download_uploaded_file(data)
      $('#dropzone-file-manager').append(template)
    
    $('#upload-video').fileupload
      url: CStoneData.vimeo.upload_link_secure
      type:'PUT'
      # headers:{'Content-Type':'video/mp4'}
      autoUpload:true
      singleFileUploads:true
      dataType: 'html'
      dropZone: $('#dropzone')
      acceptFileTypes: /(\.|\/)(mov|mpeg|mpeg4|avi|mp4|m4v)$/i
      fileTypeAllowed: /video\/(.*)/i;
      filesContainer: '#dropzone-file-manager'
      uploadTemplate:   HandlebarsTemplates.upload_uploaded_file
      downloadTemplate: HandlebarsTemplates.download_uploaded_file
      multipart:false
      send: (e, data)->
        data.headers = _(data.headers).omit('Content-Disposition')
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
      
      fail: (e,data)->
        debugger
        
      done: (e,data)->
        $.ajax
          url: "http://localhost:3000/admin/posts/video_complete_upload.json",
          type: 'DELETE',
          data:
            vimeo_complete_uri: CStoneData.vimeo.complete_uri
            vimeo_ticket_id:    CStoneData.vimeo.ticket_id
            vimeo_info_uri:     CStoneData.vimeo.uri
            
          success: (result)->
            # alert(result.vimeo_id)
            $('#post_vimeo_id').val(result.vimeo_id)
            $('.progress.progress-striped.active, .btn.btn-danger.cancel').hide()
          fail: (error, data)->
            debugger
