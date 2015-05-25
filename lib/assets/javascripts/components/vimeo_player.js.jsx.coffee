#= require shared_namespace

@CStone.Shared.Components.VimeoPlayer = React.createClass
  render: ->
    `<iframe src="https://player.vimeo.com/video/{@props.vimeo_id}" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>`
    