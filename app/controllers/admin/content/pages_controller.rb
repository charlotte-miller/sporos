class Admin::Content::PagesController < Admin::BaseController
  before_action :set_content_page, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @content_pages = Content::Page.all
    respond_with(@content_pages)
  end

  def show
    respond_with(@content_page)
  end

  def new
    @content_page = Content::Page.new
    respond_with(@content_page)
  end

  def edit
  end

  def create
    @content_page = Content::Page.new(content_page_params)
    @content_page.save
    respond_with(:admin, @content_page)
  end

  def update
    @content_page.update(content_page_params)
    respond_with(:admin, @content_page)
  end

  def destroy
    @content_page.destroy
    respond_with(:admin, @content_page)
  end

  private
    def set_content_page
      @content_page = Content::Page.friendly.find(params[:id])
    end

    def content_page_params
      params.require(:content_page).permit(:title, :body, :seo_keywords)
    end
end
