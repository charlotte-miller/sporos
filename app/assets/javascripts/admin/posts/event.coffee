$ ->
  # Date Picker
  if $('.pick-a-date').length
    $('.pick-a-date').pickadate()
    $('.trigger-pick-a-date').click (e)->
      e.preventDefault()
      e.stopPropagation()
      $('.pick-a-date').pickadate('picker').open()