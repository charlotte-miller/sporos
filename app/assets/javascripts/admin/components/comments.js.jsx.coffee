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
    approve_default:true
    # current_users_post:
    
  # getDefaultProps: ->
  
  componentDidMount: ->
    @setState poll_process: setInterval =>
      if @isMounted()
        $.getJSON "#{@props.approval_request_path}.json", (data)=>
          @setProps(data) if @isMounted()
    , 5000
  
  
  componentWillUnmount: ->
    clearInterval @state.poll_process
  
  
  current_user: ->
    @props.approvers[@props.current_user.id]
  
  author_of: (comment)->
    @props.approvers[comment.author_id]
  
  placeholder: ->
    if @props.is_author then "Any additional comments for the #{@props.post.ministry_possessive} ministry team?" else "#{@props.post.author_first_name} would appreciate feedback"
  
  handleCommentChange: (e)->
    e.preventDefault()
    @setState(comment: event.target.value)
  
  handleSubmit: (e)->
    e.preventDefault()
    url       = @refs.comment_form.props.action
    form_data = $(@refs.comment_form.getDOMNode()).serialize()
    $.post url, form_data, (data)=> 
      @setState(comment:'')
      @setProps(data)
      
  
  buildComments: ->
    _(@props.comments).map (comment)=>
      my_comment = @author_of(comment).id == @props.current_user.id
      all_comment_parts = [
       `<div className="user media-left pull-left">
          <a href="#">
            <img src={_this.author_of(comment).profile_thumb} height='64' width='64' className='img-circle media-object' alt={_this.author_of(comment).first_name+' '+_this.author_of(comment).last_name} />
          </a>
        </div>`
        ,
       `<div className="media-body">
          <h4 className="media-heading user-name">
            {_this.author_of(comment).name}
          </h4>
          <div className="comment-body">
            {comment.text}
          </div>
        </div>`
        ,
       `<div className="user media-right pull-right">
          <a href="#">
            <img src={_this.author_of(comment).profile_thumb} height='64' width='64' className='img-circle media-object' alt={_this.author_of(comment).first_name+' '+_this.author_of(comment).last_name} />
          </a>
        </div>` ]
      rm_index= if my_comment then 0 else 2
      all_comment_parts.splice(rm_index,1)
          
      `<div className="comment media" key={comment.id}>
        {all_comment_parts}
       </div>`
    
  buildApprovers: ->
    approver_pics = _(@props.approvers).map (user,id)=> `<img src={user.profile_micro} height='32' width='32' className='img-circle' title={user.name} key={id} />`
        
    `<div id="approvers">
      { approver_pics }
     </div>`
  
  buildCommentBox: ->
    `<div className="comment media">
      <div className="user media-right pull-right media-middle">
        <a href="#">
          <img src={this.current_user().profile_thumb} height='64' width='64' className='img-circle media-object' alt={this.current_user().first_name+' '+this.current_user().last_name} />
        </a>
      </div>
      <div className="media-body">
        <form onSubmit={ this.handleSubmit } ref="comment_form" className="edit_approval_request" id={"edit_approval_request_"+this.props.approval_request_id} action={"/admin/approval_requests/"+this.props.approval_request_id+".json"} acceptCharset="UTF-8" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <input type="hidden" name="_method" value="patch" />
          <input type="hidden" name="authenticity_token" value={this.xss_token} />
          <div className="form-group">           
            <textarea id="comment-field" placeholder={this.placeholder()} value={this.state.comment} onChange={this.handleCommentChange} className="form-control" name="approval_request[comment_threads_attributes][][body]"></textarea>
          </div>
          
          { this.buildApprovers() }
          
          <div className="form-group pull-right">
            <input type="submit" name="commit" value="Only Comment" className="btn btn-link" />
            <div className="btn-group dropup">
              <input type="submit" name="commit" value="Approve Post" className="btn btn-success" />
              <button className='btn btn-success dropdown-toggle' data-toggle='dropdown'>
                <span className="caret"></span>
                <span className="sr-only">Toggle Dropdown</span>
              </button>
              <ul className="dropdown-menu dropdown-menu-right" role="menu">
                <li>
                  <a href="#">Approve Post</a>
                </li>
                <li className="divider"></li>
                <li>
                  <a href="#">Reject Post</a>
                </li>
              </ul>
            </div>
          </div>
        </form>
      </div>
    </div>`
  
  render:->
    `<div id="comments">
      <h3>Feedback:</h3>
      <div id="read-comments">
        { this.buildComments() }
      </div>
      <div id="write-comments">
        { this.buildCommentBox() }
      </div>
    </div>`
