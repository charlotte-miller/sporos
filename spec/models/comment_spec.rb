# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  title            :string
#  body             :text
#  user_id          :integer          not null
#  parent_id        :integer
#  lft              :integer          not null
#  rgt              :integer          not null
#  depth            :integer          default("0"), not null
#  children_count   :integer          default("0"), not null
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_comments_on_commentable_id_and_commentable_type  (commentable_id,commentable_type)
#  index_comments_on_depth                                (depth)
#  index_comments_on_lft                                  (lft)
#  index_comments_on_parent_id                            (parent_id)
#  index_comments_on_rgt                                  (rgt)
#  index_comments_on_user_id                              (user_id)
#

require 'rails_helper'

# Specs some of the behavior of awesome_nested_set although does so to demonstrate the use of this gem
describe Comment do

  it "builds from factory", :internal do
    lambda { create(:comment) }.should_not raise_error
  end

  before do
    @user    = create(:user)
    @post    = create(:post)
    @comment = create(:comment, body: "Root comment", user: @user, commentable:@post)
  end

  describe "that is valid" do
    it "should have a user" do
      expect(@comment.user).not_to be_nil
    end

    it "should have a body" do
      expect(@comment.body).not_to be_nil
    end
  end

  it "should not have a parent if it is a root Comment" do
    expect(@comment.parent).to be_nil
  end

  it "can have see how child Comments it has" do
    expect(@comment.children.size).to eq(0)
  end

  it "can add child Comments" do
    grandchild = Comment.new(:body => "This is a grandchild", :user => @user, commentable:@post)
    grandchild.save!
    @comment.children << grandchild
    # grandchild.move_to_child_of(@comment)
    expect(@comment.children.size).to eq(1)
  end

  describe "after having a child added" do
    before do
      @child = Comment.create!(:body => "Child comment", :user => @user, commentable:@post)
      @child.move_to_child_of(@comment)
    end

    it "can be referenced by its child" do
      expect(@child.parent).to eq(@comment)
    end

    it "can see its child" do
      expect(@comment.children.first).to eq(@child)
    end
  end

  describe "finders" do
    describe "#find_comments_by_user" do
      before :each do
        @other_user = create(:user)
        @user_comment = Comment.create!(:body => "Child comment", :user => @user)
        @non_user_comment = Comment.create!(:body => "Child comment", :user => @other_user)
        @comments = Comment.find_comments_by_user(@user)
      end

      it "should return all the comments created by the passed user" do
        expect(@comments).to include(@user_comment)
      end

      it "should not return comments created by non-passed users" do
        expect(@comments).not_to include(@non_user_comment)
      end
    end

    describe "#find_comments_for_commentable" do
      before :each do
        @other_user = create(:user)
        @user_comment = Comment.create!(:body => 'from user', :commentable_type => @other_user.class.to_s, :commentable_id => @other_user.id, :user => @user)

        @other_comment = Comment.create!(:body => 'from other user', :commentable_type => @user.class.to_s, :commentable_id => @user.id, :user => @other_user)

        @comments = Comment.find_comments_for_commentable(@other_user.class, @other_user.id)
      end

      it "should return the comments for the passed commentable" do
        expect(@comments).to include(@user_comment)
      end

      it "should not return the comments for non-passed commentables" do
        expect(@comments).not_to include(@other_comment)
      end
    end
  end
end
