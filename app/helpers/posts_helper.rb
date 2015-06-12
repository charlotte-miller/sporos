module PostsHelper
  
  def ministry_class(post)
    post.ministry.slug
  end
  
  def post_type_of(post)
    post.class.name.sub(/^Posts::/,'').downcase
  end
  
  def render_partial_for(post)
    Rails.cache.fetch(post) do
      render partial:"posts/cards/#{post_type_of(post)}", locals:{post:post}
    end
  end
  
  # Only parses twice if url doesn't start with a scheme
  def get_host_domain(url)
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    # host.start_with?('www.') ? host[4..-1] : host
    host.split('.')[-2..-1].join('.')
  end
  
  def comments_data
    raise ArgumentError.new('Missing required instance variable') unless @comments && @post && @current_users_approval_request
    
    @comments_data ||= {
      approval_request_id: @current_users_approval_request.id,
      approval_request_path: admin_approval_request_path(@current_users_approval_request),
      xss_token: form_authenticity_token,
      current_user:{
        id:current_user.id,
        status: @current_users_approval_request.status ,
        is_author: current_user == @post.author },
      comments: @comments.map do |comment| 
        { id:comment.id,
          text:comment.body,
          author_id: comment.author.id }
        end,
      approvers: @post.approvers.inject({}) do|hash, approver|
        hash[approver.id]= {
          first_name:approver.first_name,
          last_name: approver.last_name,
          profile_micro: approver.profile_image.url(:micro),
          profile_thumb: approver.profile_image.url(:thumb),  }
          hash
        end,
      post:{
        ministry_possessive: @post.ministry.name.titleize.possessive,
        author_first_name: @post.author.first_name
      }
    }
  end
end
