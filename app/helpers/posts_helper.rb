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
  
  # Only parses twice if url doesn't start with a scheme
  def get_host_domain(url)
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    # host.start_with?('www.') ? host[4..-1] : host
    host.split('.')[-2..-1].join('.')
  end
end
