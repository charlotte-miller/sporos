ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
CStone.Admin.Components.GlobalNav = React.createClass

  # propTypes:
    # vimeoId: React.PropTypes.string

  getInitialState: ->
    is_open: false

  clickEdit: (e)->
    e.preventDefault()
    @setState(is_open: !@state.is_open)

  clickFeedback: (e)->
    e.preventDefault()
    doorbell.show() if doorbell?

  clickNewPostBackground:(e)->
    unless e.target.nodeName == "A"
      @setState(is_open: false)

  onNavSelect: (e)->
    e.preventDefault()
    $(e.target).addClass('opening')
    is_safari = /^((?!chrome).)*safari/i.test(navigator.userAgent)
    url = e.target.href
    _.delay ->
      window.location= url
    , (if is_safari then 500 else 0)

  buildNewPost: ->
    links = if @state.is_open
      [`<span key="event" className="new-post-type pop-1" onClick={this.clickNewPostBackground}><a onClick={this.onNavSelect} href="/admin/posts/new?post_type=event">EVENTS</a></span>`,
       `<span key="link"  className="new-post-type pop-2" onClick={this.clickNewPostBackground}><a onClick={this.onNavSelect} href="/admin/posts/new?post_type=link">LINK</a></span>`,
       `<span key="photo" className="new-post-type pop-3" onClick={this.clickNewPostBackground}><a onClick={this.onNavSelect} href="/admin/posts/new?post_type=photo">PHOTO</a></span>`,
       `<span key="video" className="new-post-type pop-4" onClick={this.clickNewPostBackground}><a onClick={this.onNavSelect} href="/admin/posts/new?post_type=video">VIDEO</a></span>`]
    else
      []
    `<ReactCSSTransitionGroup transitionName="post-create-nav" id="new-post" className={this.state.is_open ? '' : 'inactive'} onClick={this.clickNewPostBackground}>
       {links}
     </ReactCSSTransitionGroup>`

  buildEdit: ->
    if @state.is_open
      `<div>GO BACK</div>`
    else
      `<i className="glyphicon glyphicon-pencil"></i>`

  render: ->
    if $?
      if @state.is_open then $('#admin-body').addClass('blured') else $('#admin-body').removeClass('blured')
    `<div id="global-nav">
       { this.buildNewPost() }
       <div id="global-nav-bar">
        <div className="global_nav_item col-xs-3">
          <a href="/admin"><i className="glyphicon glyphicon-home"></i>
          </a>
        </div>
        <div className="global_nav_item col-xs-6" onClick={ this.clickEdit }>
          <a href="#" id="new-post-link" >
            { this.buildEdit() }
          </a>
        </div>
        <div className="global_nav_item col-xs-3">

          <a href="#" onClick={ this.clickFeedback }><i className="glyphicon glyphicon-comment"></i>
          </a>
        </div>
      </div>
    </div>`
    # <!-- = link_to "Invite",  new_user_invitations_path -->
    # <!-- = link_to "Account", edit_user_registration_path -->
    # <!-- = link_to "Logout",  destroy_user_session_path -->
