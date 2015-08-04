module ApplicationHelper

  def is_homepage?; controller_name == 'communities' ;end
  def is_library?;  current_page?(controller:'/studies', action:'index') ;end
  def main_frame?;  is_homepage? || is_library? ;end

  def main_frame_toggle
    capture_haml do
      haml_tag :div, id:'main-page', class:"view-port-page #{main_frame? ? 'current' : 'background'}" do
        yield if main_frame?
      end

      haml_tag :div, id:'page', class:"view-port-page #{'current' unless main_frame?}" do
        yield unless main_frame?
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

  def favicon_by_environment
    url = if Rails.env.development?
      image_url "development_favicon.png"
    else
      'http://static.cornerstone-sf.org/img/favicon.png'
    end

    capture_haml do
      # %link{rel:'shortcut icon', href:'http://static.cornerstone-sf.org/img/favicon.png', type:'image/x-icon'}
      haml_tag :link, rel:'shortcut icon', href:url, type:'image/x-icon'
    end
  end

  def flash_messages(opts = {})
    def bootstrap_class_for flash_type
      { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
    end

    capture_haml do
      flash.each do |msg_type, message|
        haml_tag(:div, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
          haml_tag :button, class: 'close fade in', data: { dismiss: 'alert' } do
            haml_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
            haml_tag(:span, 'Close', class: 'sr-only')
          end
          haml_concat message
        end
      end
    end
    # nil
  end

  def indefinitize(word, consonant = 'a', vowel = 'an')
    result = word.to_s.dup
    result.match(/^([aeiou])/i) ? "#{vowel} #{result}" : "#{consonant} #{result}"
  end
end
