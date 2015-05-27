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
      headers:{'Content-Type':'video/mp4'}
      autoUpload:true
      limitConcurrentUploads: 1
      dataType: 'html'
      dropZone: $('#dropzone')
      paramName: 'uploaded_file[video]'
      acceptFileTypes: /(\.|\/)(mov|mpeg|mpeg4|avi|mp4|m4v)$/i
      maxNumberOfFiles: 10
      filesContainer: '#dropzone-file-manager'
      uploadTemplate:   HandlebarsTemplates.upload_uploaded_file
      downloadTemplate: HandlebarsTemplates.download_uploaded_file
      prependFiles: true
      formData:
        name:         'title'
        description:  'description'
        license:      'by-nc-nd'
        review_link:  false
        # embed:{ },
        privacy:
          view: 'anybody'
          embed: 'public'
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
        # if xhr.status == 302
        #   $.get xhr.getResponseHeader("Location"), (response)->
            
        
      done: (e,data)->
        $.ajax
          url: "http://localhost:3000/admin/posts/video_complete_upload.json",
          type: 'DELETE',
          data:
            vimeo_complete_uri: CStoneData.vimeo.complete_uri
            vimeo_ticket_id:    CStoneData.vimeo.ticket_id
            vimeo_info_uri:     CStoneData.vimeo.uri
            
          success: (result)->
            debugger
          fail: (error, data)->
            debugger
