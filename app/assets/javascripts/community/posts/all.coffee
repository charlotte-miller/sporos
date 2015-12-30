#= require community/posts/photo
#= require admin/templates/post_management

$ ->
  $.getJSON '/admin/editable_posts', (data)->
    _(data.public_ids).each (id)->
      $placeholder = $("##{id} .post-management-placeholder")
      if $placeholder.length
        template = HandlebarsTemplates.post_management({public_id:id})
        $placeholder.replaceWith(template)

    $('.post-management-cog').click (e)->
      e.preventDefault()
      $(e.target).closest('.post-management').toggleClass('active')

    $('#posts-show .post-management').addClass('active')

  # .fail (jqXHR)-> 'not authorized' if jqXHR.status == 401
