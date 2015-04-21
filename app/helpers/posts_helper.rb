module PostsHelper
  
  def ministry_class(post)
    post.ministry.slug.downcase
  end
  
end
