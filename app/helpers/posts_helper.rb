module PostsHelper
  
  def ministry_class(post)
    post.ministry.slug
  end
  
  def post_type_of(post)
    post.class.name.sub(/^Posts::/,'').downcase
  end
  
  def render_partial_for(post)
    render partial:"posts/cards/#{post_type_of(post)}", locals:{post:post}
  end
end
