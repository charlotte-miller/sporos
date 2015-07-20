$ ->
  in_queue = 0
  $('.done-checkbox').change (e) ->
    in_queue += 1
    id = $(e.target).data('id')
    $.ajax
      url: "http://localhost:3000/admin/comm_arts_requests/#{id}/toggle_archive",
      method: "GET",
      success: (response)->
        console.log(in_queue)
        in_queue -= 1
        location.reload() unless in_queue
      fail: (error, data) ->
        console.log(error)
        console.log(data)


