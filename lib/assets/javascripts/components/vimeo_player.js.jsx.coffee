CStone.Shared.Components.VimeoPlayer = React.createClass
  propTypes:
    vimeoId: React.PropTypes.string

  render: ->
    ` <div className="vimeo-video" data-vimeo-player={'https://player.vimeo.com/video/' + this.props.vimeoId}>
        <iframe src={"https://player.vimeo.com/video/" + this.props.vimeoId }
                width="500" height="281"
                frameBorder="0"
                webkitallowfullscreen
                mozallowfullscreen
                allowFullScreen>
        </iframe>
      </div>
    `

