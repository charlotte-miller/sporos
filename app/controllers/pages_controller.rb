class PagesController < ApplicationController
  
  def show
    @page = find_or_redirect_to_page
    render html: @page.body_w_media.html_safe
  end
  
  
private

  def page_params
    @page_params ||= params.permit(:id)
  end
  
  
  # Return @page OR follow old friendly_id
  # Usage: @page = find_or_redirect_to_page || return #redirecting
  def find_or_redirect_to_page
    page = Page.friendly.find(page_params[:id]) 
    unless request.path == page_path(page)
      redirect_to( page_url(page), status: :moved_permanently ) && (return false)
    end
    return page
  end
end