#= require jquery_ujs
#= require bootstrap/dropdown
#= require pickadate
#= require pickadate/lib/picker.date
#= require pickadate/lib/picker.time
#  require clockpicker
#= require image-picker/image-picker/image-picker
#= require admin/posts/link
#= require admin/posts/event
#= require vendor_modified/jquery.unveil-1.3.0
#= require_self

$ ->
  autosize($('textarea'))
  $('img').unveil()
  

