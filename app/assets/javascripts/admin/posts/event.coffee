$ ->
  # Date Picker
  if $('.pick-a-date, pick-a-date-w-clear').length
    min_date = new Date
    max_date = (time = $('#post_event_time').val()) && new Date(time)
    $('.pick-a-date').pickadate(clear:false,           min:min_date )
    $('.pick-a-date-w-clear').pickadate(clear:'Reset', min:min_date, max:max_date )
    $('.trigger-pick-a-date').click (e)->
      e.preventDefault()
      e.stopPropagation()
      if $(e.target).parents('.input-group').find('.form-control').hasClass('pick-a-date')
        $('.pick-a-date').pickadate('picker').open()
      else
        $('.pick-a-date-w-clear').pickadate('picker').open()

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