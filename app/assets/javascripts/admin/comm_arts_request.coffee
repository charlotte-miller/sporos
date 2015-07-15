$ ->
  $('.done-checkbox').change (e) ->
    id = $(e.target).data('id')
    $.ajax
      url: "http://localhost:3000/admin/comm_arts_requests/#{id}/toggle_archive",
      method: "GET",
      success: (result) ->
        location.reload()
      fail: (error, data) ->
        console.log(error)
        console.log(data)

