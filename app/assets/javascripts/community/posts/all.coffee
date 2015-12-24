#= require community/posts/photo

$ ->
  $('.post-management-cog').click (e)->
    e.preventDefault()
    $(e.target).closest('.post-management').toggleClass('active')

  $('#posts-show .post-management').addClass('active')
