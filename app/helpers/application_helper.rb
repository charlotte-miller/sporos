module ApplicationHelper
  
  def is_homepage?
    current_page?(controller:'special_pages', action:'homepage')
  end
  
  def homepage_toggle
    capture_haml do
      haml_tag :div, id:'main-page', class:"view-port-page #{'current' if is_homepage?}" do
        yield if is_homepage?
      end
    
      haml_tag :div, id:'page', class:"view-port-page #{'current' unless is_homepage?}" do
        yield unless is_homepage?
      end
    end
  end
  
  def universal_favicons
    # / For third-generation iPad with high-resolution Retina display:
    # / Size should be 144 x 144 pixels
    favicons = [] << favicon_link_tag( 'images/apple-touch-icon-144x144-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '144x144' )
    
    # / For iPhone with high-resolution Retina display:
    # / Size should be 114 x 114 pixels
    favicons << favicon_link_tag( 'images/apple-touch-icon-114x114-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '114x114' )
    
    # / For first- and second-generation iPad:
    # / Size should be 72 x 72 pixels
    favicons << favicon_link_tag( 'images/apple-touch-icon-72x72-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png', :sizes => '72x72' )
    
    # / For non-Retina iPhone, iPod Touch, and Android 2.1+ devices:
    # / Size should be 57 x 57 pixels
    favicons << favicon_link_tag( 'images/apple-touch-icon-precomposed.png', :rel => 'apple-touch-icon-precomposed', :type => 'image/png' )
    
    # / For all other devices
    # / Size should be 32 x 32 pixels
    favicons << favicon_link_tag( 'favicon.ico', :rel => 'shortcut icon' )
    favicons.join("\n").html_safe
  end
end
