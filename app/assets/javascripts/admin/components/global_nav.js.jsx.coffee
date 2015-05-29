CStone.Admin.Components.GlobalNav = React.createClass
  
  # propTypes:
    # vimeoId: React.PropTypes.string
    
  # getInitialState: ->
    # value: this.props.vimeoId
    
  # handleChange: (event)->
  #   vimeo_id = event.target.value.replace /\D*(\d*)\D*/, "$1"
  #   @setProps
  #     vimeoId: vimeo_id
  #   @setState
  #     value: vimeo_id
  #
  # handleClick: (event)->
  #   event.target.setSelectionRange(0, event.target.value.length)
  
  clickEdit: (e)->
    e.preventDefault()
    $('#admin-body').toggleClass('blured')
    $('#new-post-types').removeClass('notransition')
    $('#new-post-types').toggleClass('active')
  
  render: ->
    `<div id="global-nav">
       <nav id="new-post">
         <div id="new-post-types" className="disabled">
           <a className="new-post-type" href="/admin/posts/new?post_type=event"><span className="pop-1">EVENTS</span></a>
           <a className="new-post-type" href="/admin/posts/new?post_type=link"><span  className="pop-2">LINK</span></a>
           <a className="new-post-type" href="/admin/posts/new?post_type=photo"><span className="pop-3">PHOTO</span></a>
           <a className="new-post-type" href="/admin/posts/new?post_type=video"><span className="pop-4">VIDEO</span></a>
         </div>
       </nav>
       <div id="global-nav-bar">
        <div className="global_nav_item col-xs-3">
          <a href="/admin"><i className="glyphicon glyphicon-home"></i>
          </a>
        </div>
        <div className="global_nav_item col-xs-6" onClick={ this.clickEdit }>
          <a href="#" id="new-post-link" >
            <i className="glyphicon glyphicon-pencil"></i>
          </a>
        </div>
        <div className="global_nav_item col-xs-3">

          <a href="/admin/ministries"><i className="glyphicon glyphicon-cog"></i>
          </a>
        </div>
      </div>
    </div>`
    # <!-- = link_to "Invite",  new_user_invitations_path -->
    # <!-- = link_to "Account", edit_user_registration_path -->
    # <!-- = link_to "Logout",  destroy_user_session_path -->