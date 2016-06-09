require 'test_helper'

class UserTagsControllerTest < ActionController::TestCase

  def setup
    activate_authlogic
  end

  test "should create a new tags" do
    UserSession.create(rusers(:bob))
    post :create, :type => 'skill', :value => 'environment'
    assert_equal "environment tag created successfully", flash[:notice]
    assert_redirected_to info_path
  end

  test "should delete existing tag" do
    UserSession.create(rusers(:bob))
    user_tag = user_tags(:one)
    post :delete, :id => user_tag.id
    assert_equal "Tag deleted.", flash[:notice]
    assert_redirected_to info_path
  end

  test "cannot delete non-existent tag" do
    UserSession.create(rusers(:bob))
    post :delete, :id => 9999
    assert_equal "Tag doesn't exist.", flash[:error]
    assert_redirected_to info_path
  end

  test "should not create duplicate tag" do
    UserSession.create(rusers(:bob))
    post :create, :type => 'skill', :value => 'environment'
    # duplicate tag
    post :create, :type => 'skill', :value => 'environment'
    assert_equal "Error: tag already exists.", assigns['output']['errors'][0]
    assert_redirected_to info_path
  end

  test "should not create invalid tag" do
    UserSession.create(rusers(:bob))
    valid_tags = ['skill', 'gear', 'role', 'tool']
    valid_tags.each do |tag|
      post :create, :type => tag, :value => 'tagvalue'
      assert_equal "tagvalue tag created successfully", flash[:notice]
      assert_redirected_to info_path
    end

    invalid_tags = ['skills', 'abc', '123']
    invalid_tags.each do |tag|
      post :create, :type => tag, :value => 'tagvalue'
      assert_equal "Error: Invalid value #{tag}", assigns['output']['errors'][0]
    end
  end

  test "should not allow empty tag value" do
    UserSession.create(rusers(:bob))
    post :create, :type => "skill", :value => ''
    assert_equal "Error: value cannot be empty", assigns['output']['errors'][0]
    assert_redirected_to info_path
  end
end
