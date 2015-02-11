$ ->
  # Trims whitespace so empty html is falsy
  jQuery.fn.trim_html = ->
    html_str = @html()
    html_str && html_str.trim()