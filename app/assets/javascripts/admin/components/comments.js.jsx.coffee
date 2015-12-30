ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
CStone.Admin.Components.Comments= React.createClass

  propTypes:
    approval_request_id: React.PropTypes.number.isRequired
    approval_request_path: React.PropTypes.string.isRequired
    post: React.PropTypes.shape
      ministry_possessive: React.PropTypes.string.isRequired
      author_first_name: React.PropTypes.string.isRequired
    current_user: React.PropTypes.shape
      id:     React.PropTypes.number.isRequired
      status: React.PropTypes.string.isRequired
      is_author: React.PropTypes.bool.isRequired
    approvers: React.PropTypes.objectOf React.PropTypes.shape
      first_name: React.PropTypes.string.isRequired
      last_name:  React.PropTypes.string.isRequired
      profile_micro: React.PropTypes.string.isRequired
      profile_thumb: React.PropTypes.string.isRequired
    comments: React.PropTypes.arrayOf React.PropTypes.shape
      id: React.PropTypes.number.isRequired
      text: React.PropTypes.string.isRequired
      author_id: React.PropTypes.number.isRequired

  getInitialState: ->
    comment:''
    approve_default: @props.current_user.status != 'rejected'
    already_decided: @props.current_user.status != 'pending'
    archived:        @props.current_user.status == 'archived'
    presentation_order: ['AUTHOR', 'LEADER', 'EDITOR']

  # getDefaultProps: ->

  componentDidMount: ->
    chartDOM = document.getElementById("global-approval-chart").getContext("2d")

    @setState
      poll_process: setInterval =>
        if @isMounted()
          $.getJSON "#{@props.approval_request_path}.json", (data)=>
            @setProps(data) if @isMounted()
      , 5000
      approvalChart: new Chart(chartDOM).Doughnut @approvalChartData(), {animationEasing:'easeInOutQuint', percentageInnerCutout:80}

    setTimeout =>
      @setState( animate_comments:true ) if @isMounted()
    , 1000

    @hackPostStatus()


  componentWillUnmount: ->
    clearInterval @state.poll_process

  componentDidUpdate: ->
    @hackPostStatus()

  current_user: ->
    @props.approvers[@props.current_user.id]

  author_of: (comment)->
    @props.approvers[comment.author_id]

  placeholder: ->
    if @props.is_author then "Any additional comments for the #{@props.post.ministry_possessive} ministry team?" else "#{@props.post.author_first_name} would appreciate feedback"

  proposed_status: ->
    if @state.approve_default then 'accepted' else 'rejected'

  approvalChartData: ->
    # [{
    #     value: 100,
    #     color:"#5cb85c",
    #     highlight: "#FF5A5E",
    #     label: "Author"
    # },
    # {
    #     value: 100,
    #     color: "#5cb85c",
    #     highlight: "#5AD3D1",
    #     label: "Leader"
    # },
    # {
    #     value: 100,
    #     color: "#777777",
    #     highlight: "#FFC870",
    #     label: "Editor"
    # }]
    color = (state)->
      switch state
        when 'accepted' then "#5cb85c"
        when 'rejected' then "#b92c28"
        else "#777777"

    _(@props.approval_statuses).chain().map (status,role)->
      value:1
      color:color(status)
      color:color(status)
      fillColor:color(status)
      highlightColor:color(status)
      role:role
      label:role
    .sortBy (obj)=> _(@state.presentation_order).indexOf(obj.role)
    .value()



  handleCommentChange: (e)->
    e.preventDefault()
    @setState(comment: event.target.value)

  handleApprovalStatusSubmit: (e, options={})->
    e.preventDefault()
    url       = @refs.comment_form.props.action
    $form     = $('input, textarea', @refs.comment_form.getDOMNode())
    $form     = $form.not('#approval_request_status') if options.without_status
    form_data = $form.serialize()
    $.post url, form_data, (data)=>
      @setProps(data)
      new_state_data = { comment:'' }
      unless options.without_status
        _(new_state_data).extend
          approve_default: @props.current_user.status != 'rejected'
          already_decided: @props.current_user.status != 'pending'
      @setState new_state_data

  handleToggleStatus: (e,default_to_approve)->
    e.preventDefault()
    if @state.approve_default != default_to_approve
      @setState
        approve_default: default_to_approve
        already_decided: @props.current_user.status == if default_to_approve then 'accepted' else 'rejected'

  handleOnlyComment: (e)->
    e.preventDefault()
    @handleApprovalStatusSubmit(e, {without_status:true})

  hackPostStatus: ->
    # intermediate hack -- pending approval refactor
    vintage_post_status_string = @state.post_status_string
    ballot_box = _(@props.approval_statuses).inject( (obj, vote, voter)->
      obj[vote].push voter
      obj
    , {accepted:[], rejected:[], undecided:[]}) #defaults

    if ballot_box.rejected.length
      post_status_string= 'CLOSED'
    else
      percentage = parseInt( ballot_box.accepted.length / _(@props.approval_statuses).keys().length *100 )
      if percentage < 100
        post_status_string= 'PENDING'
      else
        post_status_string= 'PUBLISHED'

    unless vintage_post_status_string == post_status_string
      @setState(post_status_string: post_status_string)
      $('#post-status').text(post_status_string)

  buildComments: ->
    _(@props.comments).map (comment)=>
      all_comment_parts = [
       `<div className="user media-left">
          <a href="#" title={_this.author_of(comment).first_name +' '+ _this.author_of(comment).last_name}>
            <img src={_this.author_of(comment).profile_thumb} height='64' width='64' className='img-circle media-object' alt={_this.author_of(comment).first_name+' '+_this.author_of(comment).last_name} />
          </a>
          <div className="tri-left"></div>
        </div>`
        ,
       `<div className="media-body">
          <h4 className="media-heading user-name">
            {_this.author_of(comment).name}
          </h4>
          <div className="comment-body word-bubble">
            {comment.text}
          </div>
        </div>`
        ,
       `<div className="user media-right media-bottom">
          <div className="tri-right"></div>
          <a href="#" title={_this.author_of(comment).first_name +' '+ _this.author_of(comment).last_name}>
            <img src={_this.author_of(comment).profile_thumb} height='64' width='64' className='img-circle media-object' alt={_this.author_of(comment).first_name+' '+_this.author_of(comment).last_name} />
          </a>
        </div>` ]
      my_comment = comment.author_id == @props.current_user.id
      rm_index= if my_comment then 0 else 2
      all_comment_parts.splice(rm_index,1)

      classes = React.addons.classSet
        comment: true
        media: true
        'my-comment': my_comment
        animated:true
        fadeInUp:true
        'instant-animation': !@state.animate_comments

      `<div className={classes} key={comment.id}>
        {all_comment_parts}
       </div>`

  buildApprovers: ->
    approver_pics = _(@props.approvers).map (user,id)=> `<img src={user.profile_micro} height='32' width='32' className='img-circle' title={user.name} key={id} />`

    `<div id="approvers">
      { approver_pics }
     </div>`

  buildCommentSubmitButton: ->
    `<div id="comment-buttons">
      <input onClick={ this.handleOnlyComment } id="add-comment-btn" type="submit" name="commit" value="Comment" className="btn btn-primary" />
     </div>`

  buildApprovalSubmitButton: ->
    classes = (options={})=>
      React.addons.classSet( _({
        'btn':true
        'btn-success' : @state.approve_default
        'btn-danger'  : !@state.approve_default
        'disabled'    : @state.already_decided
      }).extend(options))

    btn_cta = if @state.already_decided
      status_title = if @state.approve_default then 'Approved' else 'Rejected'
      "You #{status_title}"
    else if @state.approve_default
      "Approve Post"
    else
      " Reject Post"

    context = @
    unless @state.archived
      `<div className="btn-group dropup">
         <input type="submit" name="commit" value={btn_cta} className={ classes() } onClick={ this.handleApprovalStatusSubmit } />
         <button className={classes({'dropdown-toggle':true, disabled:false})} data-toggle='dropdown'>
           <span className="caret"></span>
           <span className="sr-only">Toggle Dropdown</span>
         </button>
         <ul className="dropdown-menu dropdown-menu-right" role="menu">
           <li>
             <a href="#" onClick={ function(e){ context.handleToggleStatus(e, true) } }>Approve Post</a>
           </li>
           <li className="divider"></li>
           <li>
             <a href="#" onClick={ function(e) { context.handleToggleStatus(e, false) }  }>Reject Post</a>
           </li>
         </ul>
       </div>`


  buildApprovalStatus: ->
    if @state.approvalChart?
      vintageSegmentsStr = _(@state.approvalChart.segments).pluck('fillColor').join(', ')
      @state.approvalChart.segments = _( @approvalChartData() ).map (data_obj)=>
        _(@state.approvalChart.segments).chain()
        .findWhere label:data_obj.label
        .tap (me)-> _(me).extend(data_obj)
        .value()

      if vintageSegmentsStr != _(@state.approvalChart.segments).pluck('fillColor').join(', ')
        @state.approvalChart.update()

    ballot_box = _(@props.approval_statuses).inject( (obj, vote, voter)->
      obj[vote].push voter
      obj
    , {accepted:[], rejected:[], undecided:[]}) #defaults

    if ballot_box.rejected.length
      percentage = `<i className="glyphicon glyphicon-comment"><small>Learn More</small></i>`
      help_message = 'Find out more by chatting with your team:'
      message = 'This post has been rejected (for now)'
    else
      percentage = "#{parseInt( ballot_box.accepted.length / _(@props.approval_statuses).keys().length *100 )}%"
      help_message = 'Required before a post is published or updated.'
      message = _(ballot_box.undecided).chain()
      .sortBy (role)=> _(@state.presentation_order).indexOf(role)
      .map (role)->
        titleized = role.replace /\w\S*/g, (txt)->
          txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
        `<strong>{titleized}</strong>`
      .value()

      if message.length > 1
        message.splice(1, 0, `<span>, </span>`) if message.length == 3
        message = message.concat [`<span> &amp; </span>`, message.pop()]
      message.push(`<span> Approval Required</span>`)



    `<div id="approval-status-row">
      <div className="global-approval-status col-xs-4">
        <div className="">
          <canvas id="global-approval-chart" width="120" height="120"></canvas>
          <div className="chart-center">
            { percentage }
          </div>
        </div>
      </div>
      <div className="col-xs-8 approval-status-right">
        <div className="row approval-status-right">
          <div className="col-sm-7">
            <h4>
              { message }
            </h4>
            <div className="hidden-sm hidden-xs info-i">
              <i className="glyphicon glyphicon-info-sign"> </i>
              { help_message }
            </div>
          </div>
          <div className="col-sm-5">
            { this.buildApprovalSubmitButton() }
          </div>
        </div>
      </div>
    </div>`

  buildCommentBox: ->
    `<form onSubmit={ this.handleOnlyComment } ref="comment_form" className="edit_approval_request" id={"edit_approval_request_"+this.props.approval_request_id} action={"/admin/approval_requests/"+this.props.approval_request_id+".json"} acceptCharset="UTF-8" method="post">
      <input name="utf8" type="hidden" value="&#x2713;" />
      <input type="hidden" name="_method" value="patch" />
      <input type="hidden" name="authenticity_token" value={this.xss_token} />
      <input type="hidden" name="approval_request[status]" value={this.proposed_status()} id="approval_request_status" />
      <div className="comment media my-comment">
        <div className="media-body">
          <div id="comment-field" className="word-bubble">
            <textarea placeholder={this.placeholder()} value={this.state.comment} onChange={this.handleCommentChange} className="form-control" name="approval_request[comment_threads_attributes][][body]"></textarea>
          </div>
        </div>
        <div className="user media-right media-bottom">
          <div className="tri-right"></div>
          <a href="#" title="Me">
            <img src={this.current_user().profile_thumb} height='64' width='64' className='img-circle media-object' alt={this.current_user().first_name+' '+this.current_user().last_name} />
          </a>
        </div>
      </div>
      <div id="comment-submit-row">
        { this.buildApprovers() }
        { this.buildCommentSubmitButton() }
      </div>
    </form>`

  render:->
    `<div>
       <div id="approval-status">
         <h3>Approval Status</h3>
         { this.buildApprovalStatus() }
       </div>
       <div id="comments">
        <h3>Discussion:</h3>
        <div id="read-comments">
          { this.buildComments() }
        </div>
        <div id="write-comments">
          { this.buildCommentBox() }
        </div>
      </div>
    </div>`
