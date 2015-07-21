$ ->
  $('#email_field').keypress (e) ->
    if (e.which == 13)
      go_to_sign_up()
      return false

  $('#join_button').click ->
    go_to_sign_up()

  go_to_sign_up = ()->
    email_val = $('#email_field').val()
    window.location.href = "/users/sign_up?email=#{email_val}&location=#{window.location.pathname}"

