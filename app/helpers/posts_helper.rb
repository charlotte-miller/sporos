module PostsHelper
  
  def ministry_class(post)
    post.ministry.slug
  end
  
  def post_type_of(post)
    post.class.name.sub(/^Posts::/,'').downcase
  end
end
