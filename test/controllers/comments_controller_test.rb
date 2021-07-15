require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'Sam Smith',
                         email: 'sam@example.com',
                         password: 'welcome',
                         password_confirmation: 'welcome')
    @task = @user.tasks.create!(title: 'Learn Ruby')
    @headers = headers(@user)
  end

  def test_should_create_comment_for_valid_request
    content = 'Wow!'
    post comments_url, params: { comment: { content: content, task_id: @task.id } }, headers: @headers
    assert_response :success
    assert_equal @task.comments.last.content, content
  end

  def test_shouldnt_create_comment_without_content
    post comments_url, params: { comment: { content: '', task_id: @task.id } }, headers: @headers
    assert_response :unprocessable_entity
    response_json = response.parsed_body
    assert_equal response_json['errors'], "Content can't be blank"
  end
end
