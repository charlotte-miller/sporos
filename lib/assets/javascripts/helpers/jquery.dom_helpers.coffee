$ ->
  # Trims whitespace so empty html is falsy
  jQuery.fn.trim_html = ->
    html_str = @html()
    html_str && html_str.trim()

  jQuery.fn.moveTo = (to_selector)->
    @detach().appendTo(to_selector)

  jQuery.fn.moveContentTo = (to_selector)->
    @children().detach().appendTo(to_selector)
