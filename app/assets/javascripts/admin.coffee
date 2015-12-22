#= require handlebars/handlebars.runtime.js
#= require jquery_ujs
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
#= require jquery-file-upload/js/jquery.fileupload-ui
#= require bootstrap/dropdown
#= require bootstrap/tab
#= require bootstrap/transition
#= require bootstrap/collapse
#= require pickadate/lib/picker
#= require pickadate/lib/picker.date
#= require pickadate/lib/picker.time
#  require clockpicker
#= require image-picker/image-picker/image-picker
#= require Chart.js/src/Chart.Core
#= require Chart.js/src/Chart.Doughnut
#
#= require application_namespace
#= require shared
#= require admin/posts/link
#= require admin/posts/event
#= require admin/posts/photo
#= require admin/posts/video
#= require admin/comm_arts_request
#= require vendor_modified/jquery.unveil-1.3.0
#= require_tree ./admin/components
#= require_self


$ ->
  autosize($('textarea'))
  $('img').unveil()


  $messages = $('#onboarding_messages')
  $('.read-more', $messages).click (e)->
    e.preventDefault()
    $messages.removeClass('preview')


