CStone.Admin.Components.VimeoUploadHelp = React.createClass

  propTypes:
    vimeoId: React.PropTypes.string

  getInitialState: ->
    value: this.props.vimeoId

  handleChange: (event)->
    vimeo_id = event.target.value.replace /\D*(\d*)\D*/, "$1"
    @setProps
      vimeoId: vimeo_id
    @setState
      value: vimeo_id

  handleClick: (event)->
    event.target.setSelectionRange(0, event.target.value.length)

  render: ->
    if @props.vimeoId && @props.vimeoId.length > 8
      `<div className="well">
         <div className="input-group">
           <span className="input-group-addon">https://vimeo.com/</span>
           <input onChange={this.handleChange} onClick={ this.handleClick } className="form-control" placeholder="116585056" type="text" value={ this.state.value } name="post[vimeo_id]" id="post_vimeo_id" />
         </div>
         <CStone.Shared.Components.VimeoPlayer vimeoId={ this.props.vimeoId } />
       </div>`

    else
      `<div className="well">
         <div className="input-group">
           <span className="input-group-addon">https://vimeo.com/</span>
           <input onChange={this.handleChange} onClick={ this.handleClick } className="form-control" placeholder="116585056" type="text" value={ this.state.value } name="post[vimeo_id]" id="post_vimeo_id" />
         </div>
         <div className="help-block">
          <div className="col-xs-5">
            <a href="/static/images/vimeo-id-help.png"><img src="/static/images/vimeo-id-help.png" alt="Vimeo id help"/></a>
          </div>
          <div className="col-xs-7">
            <span>
              <b>Type or paste the video's Vimeo link.</b>
            </span>
            <br />
            <span>
              Example:
              <a href="https://vimeo.com/116585056" target="_blank">https://vimeo.com/116585056</a>
            </span>
          </div>
        </div>
      </div>`
