$ ->
  if $('#post_vimeo_id').length
    $('#post_vimeo_id').on 'paste change', ->
      _.defer =>
        vimeo_id = $(@).val().replace /\D*(\d*)\D*/, "$1"
        $(@).val vimeo_id
        
    $('#post_vimeo_id').click ->
      @.setSelectionRange(0, @.value.length)
  