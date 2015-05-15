$ ->

  resizeCenterImage = ($image) ->
    # `var newnewheight`
    # `var newratio`
    # `var newnewwidth`
    # `var newwidth`
    # `var ratio`
    # `var newheight`
    theImage = new Image
    theImage.src = $image.attr('src')
    imgwidth = theImage.width
    imgheight = theImage.height
    containerwidth = 460
    containerheight = 330
    if imgwidth > containerwidth
      newwidth = containerwidth
      ratio = imgwidth / containerwidth
      newheight = imgheight / ratio
      if newheight > containerheight
        newnewheight = containerheight
        newratio = newheight / containerheight
        newnewwidth = newwidth / newratio
        theImage.width = newnewwidth
        theImage.height = newnewheight
      else
        theImage.width = newwidth
        theImage.height = newheight
    else if imgheight > containerheight
      newheight = containerheight
      ratio = imgheight / containerheight
      newwidth = imgwidth / ratio
      if newwidth > containerwidth
        newnewwidth = containerwidth
        newratio = newwidth / containerwidth
        newnewheight = newheight / newratio
        theImage.height = newnewheight
        theImage.width = newnewwidth
      else
        theImage.width = newwidth
        theImage.height = newheight
    $image.css
      'width': theImage.width
      'height': theImage.height
      'margin-top': -(theImage.height / 2) - 10 + 'px'
      'margin-left': -(theImage.width / 2) - 10 + 'px'
    return

  $ps_container = $('#ps_container')
  $ps_overlay = $('#ps_overlay')
  $ps_close = $('#ps_close')

  ###*
  * when we click on an album,
  * we load with AJAX the list of pictures for that album.
  * we randomly rotate them except the last one, which is
  * the one the User sees first. We also resize and center each image.
  ###

  $('.photo-gallery').click (e)->
    e.preventDefault()
    $elem = $(this)
    post_path = $elem.attr('href')
    $loading = $('<div />', className: 'loading')
    $elem.append $loading
    $ps_container.find('img').remove()
    $.getJSON post_path, (data) ->
      last_file = _(data.files).last()
      _(data.files).each (img_url)->
        $('<img />').load(->
          $image = $(this)
          resizeCenterImage $image
          $ps_container.append $image
          r = Math.floor(Math.random() * 41) - 20
          
          if img_url == last_file
            $loading.remove()
            $ps_container.show()
            $ps_close.show()
            $ps_overlay.show()
          else
            $image.css
              '-moz-transform': 'rotate(' + r + 'deg)'
              '-webkit-transform': 'rotate(' + r + 'deg)'
              'transform': 'rotate(' + r + 'deg)'

        ).attr 'src', img_url

  ###*
  * when hovering each one of the images,
  * we show the button to navigate through them
  ###

  $ps_container.on 'mouseenter', -> $('#ps_next_photo').show()
  $ps_container.on 'mouseleave', -> $('#ps_next_photo').hide()

  ###*
  * navigate through the images:
  * the last one (the visible one) becomes the first one.
  * we also rotate 0 degrees the new visible picture
  ###

  $('#ps_next_photo').on 'click', ->
    $current = $ps_container.find('img:last')
    r = Math.floor(Math.random() * 41) - 20
    currentPositions =
      marginLeft: $current.css('margin-left')
      marginTop: $current.css('margin-top')
    $new_current = $current.prev()
    $current.animate {
      'marginLeft': '250px'
      'marginTop': '-385px'
    }, 250, ->
      $(this).insertBefore($ps_container.find('img:first')).css(
        '-moz-transform': 'rotate(' + r + 'deg)'
        '-webkit-transform': 'rotate(' + r + 'deg)'
        'transform': 'rotate(' + r + 'deg)').animate {
        'marginLeft': currentPositions.marginLeft
        'marginTop': currentPositions.marginTop
      }, 250, ->
        $new_current.css
          '-moz-transform': 'rotate(0deg)'
          '-webkit-transform': 'rotate(0deg)'
          'transform': 'rotate(0deg)'
        return
      return
    return

  ###*
  * close the images view, and go back to albums
  ###

  $('#ps_close, #ps_overlay').bind 'click', ->
    $ps_container.hide()
    $ps_close.hide()
    $ps_overlay.fadeOut 400
    return
  return
