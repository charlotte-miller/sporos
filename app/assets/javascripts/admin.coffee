#= require jquery_ujs
#= require bootstrap/dropdown
#= require pickadate
#= require pickadate/lib/picker.date
#  require clockpicker

$ ->
  autosize($('textarea'))
  
  if $('.pick-a-date').length
    $('.pick-a-date').pickadate()
    $('.trigger-pick-a-date').click (e)->
      e.preventDefault()
      e.stopPropagation()
      $('.pick-a-date').pickadate('picker').open()

  loadUrlPreview = (external_url)->
    unless external_url.length
      $('#external-url-details').removeClass('populated')
      _.delay ->
        $('#post_title').val('')
        $('#post_description').val('')
      , 100
      return
    
    $('#instrutions').addClass('loading')
    $('#external-url-field, #post-form-submit').prop('disabled', true)
    
    promise = $.getJSON "/admin/posts/link_preview?url=#{external_url}"
    promise.done (preview)->
      $('#post_title').val(preview.title)
      $('#post_description').val(preview.description)
      autosize.update $('#post_description')
      $('#external-url-details').addClass('populated')
    promise.fail (failure)->
      $('#external-url-details').removeClass('populated')
      _.delay ->
        $('#post_title').val('')
        $('#post_description').val('')
      , 100
    promise.always ->
      $('#external-url-field, #post-form-submit').prop('disabled', false)
      $('#instrutions').removeClass('loading')
      
  $('#external-url-field').on 'paste', ->
    _.defer =>
      loadUrlPreview $(@).val()
      
  
  $('#external-url-field').on 'change', (e)->
    loadUrlPreview $(@).val()
    
  $('#external-url-field').click ->
    @.setSelectionRange(0, @.value.length)
  
  $('#external-url-field').focus()
  