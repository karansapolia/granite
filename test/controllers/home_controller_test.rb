require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.create!(name: 'Sam smith',
                         email: 'sam@example.com',
                         password: 'welcome',
                         password_confirmation: 'welcome')
    @task = @user.tasks.create!(title: 'Learn Rails', creator_id: @user.id)
    @headers = headers(@user)
  end

  def test_should_get_successfully_from_root_url
    get root_url
    assert_response :success
  end

  def test_should_list_all_tasks_for_valid_user
    get tasks_url, headers: @headers
    assert_response :success
    response_body = response.parsed_body
    all_tasks = response_body['tasks']

    pending_tasks_count = Task.where(progress: 'pending').count
    completed_tasks_count = Task.where(progress: 'completed').count

    assert_equal all_tasks['pending'].length, pending_tasks_count
    assert_equal all_tasks['completed'].length, completed_tasks_count
  end

  def test_should_create_valid_task
    post tasks_url, params: { task: { title: 'Leanr Ruby', user_id: @user.id }}, headers: @headers
    assert_response :success
    response_json = response.parsed_body
    assert_equal response_json['notice'], t('successfully_created', entity: 'Task')
  end

  def test_shouldnt_create_task_without_title
    post tasks_url, params: { task: { title: '', user_id: @user.id } }, headers: @headers
    assert_response :unprocessable_entity
    response_json = response.parsed_body
    assert_equal response_json['errors'], "Title can't be blank"
  end

  def test_should_update_task
    new_title = 'Learn React'
    slug_url = "/tasks/#{@task.slug}"
    task_params = { task: { title: new_title, user_id: 1, authorize_owner: true } }

    put slug_url, params: task_params, headers: @headers
    assert_response :success
    @task.reload
    assert_equal @task.title, new_title
  end

  def test_should_destroy_task
    initial_task_count = @user.tasks.size
    slug_url = "/tasks/#{@task.slug}"

    delete slug_url, headers: @headers
    assert_response :success
    assert_equal @user.tasks.size, initial_task_count - 1
  end
end
