require 'rails_helper'

RSpec.describe "admin/posts/new", :type => :view do
  before(:all) do
    @ministries = assign(:ministries, [build_stubbed(:ministry)])
  end
  
  before(:each) do
    view.stub(:current_user) { User.new }
  end
  
  context 'Posts::Event' do
    before do
      @post = assign(:post, Posts::Event.new(
        :title => "MyText",
        :description => "MyText",
        :display_options => {},
        :poster => ""
      ))
    end
    
    it "renders new post form" do
      render

      assert_select "form[action=?][method=?]", admin_posts_path, "post" do
        assert_select "input#post_type[name=?]", "post[type]", value:'Posts::Event'
        assert_select "input#post_title[name=?]", "post[title]"
        assert_select "textarea#post_description[name=?]", "post[description]"
        # assert_select "input#post_poster[name=?]", "post[poster]"
      
        # assert_select "input#post_url[name='post[display_options][url]']"
      end
    end
  end

  context 'Posts::Link' do
    before do
      @post = assign(:post, Posts::Link.new(
        :title => "MyText",
        :description => "MyText",
        :display_options => {},
        :poster => ""
      ))
      @possible_poster_images = assign(:possible_poster_images, [])
    end
    it "renders new post form" do
      render

      assert_select "form[action=?][method=?]", admin_posts_path, "post" do
        assert_select "input#post_type[name=?]", "post[type]", value:'Posts::Link'
        assert_select "input#post_title[name=?]", "post[title]"
        assert_select "textarea#post_description[name=?]", "post[description]"
        # assert_select "input#post_poster[name=?]", "post[poster]"
      
        # assert_select "input#post_url[name='post[display_options][url]']"
      end
    end
  end
  
  context 'Posts::Photo' do
    before do
      @post = assign(:post, Posts::Photo.new(
        :title => "MyText",
        :description => "MyText",
        :display_options => {},
        :poster => ""
      ))
    end
    it "renders new post form" do
      render

      assert_select "form[action=?][method=?]", admin_posts_path, "post" do
        assert_select "input#post_type[name=?]", "post[type]", value:'Posts::Photo'
        assert_select "input#post_title[name=?]", "post[title]"
        assert_select "textarea#post_description[name=?]", "post[description]"
        # assert_select "input#post_poster[name=?]", "post[poster]"
      
        # assert_select "input#post_url[name='post[display_options][url]']"
      end
    end
  end
  
  context 'Posts::Video' do
    before do
      @post = assign(:post, Posts::Video.new(
        :title => "MyText",
        :description => "MyText",
        :display_options => {},
        :poster => ""
      ))
    end
    it "renders new post form" do
      render

      assert_select "form[action=?][method=?]", admin_posts_path, "post" do
        assert_select "input#post_type[name=?]", "post[type]", value:'Posts::Video'
        assert_select "input#post_title[name=?]", "post[title]"
        assert_select "textarea#post_description[name=?]", "post[description]"
        # assert_select "input#post_poster[name=?]", "post[poster]"
      
        # assert_select "input#post_url[name='post[display_options][url]']"
      end
    end
  end
  
   
end
