require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: 'Sam Smith',
                        email: 'sam@example.com',
                        password: 'welcome',
                        password_confirmation: 'welcome')
    @task = Task.new(title: 'This is a test task', user: @user)
  end

  def test_instance_of_task
    assert_instance_of Task, @task
  end

  def test_not_instance_of_user
    assert_not_instance_of User, @task
  end

  def test_value_of_title_assigned
    task = Task.new(title: "Title assigned for testing")
    assert_equal "Title assigned for testing", task.title
  end

  def test_value_created_at
    assert_nil @task.created_at

    @task.save!
    assert_not_nil @task.created_at
  end

  test "error raised" do
    assert_raises ActiveRecord::RecordNotFound do
      Task.find(SecureRandom.uuid)
    end
  end

  def test_count_of_number_of_tasks
    assert_difference ['Task.count'], 2 do
      Task.create!(title: 'Creating a task through test', user: @user)
      Task.create!(title: 'Creating another task through test', user: @user)
    end
  end

  def test_task_should_not_be_valid_without_title
    @task.title = nil
    puts @task.title
    assert @task.invalid?
  end

  def test_task_slug_is_parameterized_title
    title = @task.title
    @task.save!
    assert_equal title.parameterize, @task.slug
  end

  def test_incremental_slug_generation_for_tasks_with_same_title
    first_task = Task.create!(title: 'test task', user: @user)
    second_task = Task.create!(title: 'test task', user: @user)

    assert_equal 'test-task', first_task.slug
    assert_equal 'test-task-2', second_task.slug
  end

  def test_error_raised_for_duplicate_slug
    test_task = Task.create!(title: 'test task', user: @user)
    another_test_task = Task.create!(title: 'another test task', user: @user)

    test_task_title = test_task.title
    assert_raises ActiveRecord::RecordInvalid do
      another_test_task.update!(slug: test_task_title.parameterize)
    end

    assert_match t('task.slug.immutable'), another_test_task.errors.full_messages.to_sentence
  end

  def test_updating_title_does_not_update_slug
    @task.save!
    task_slug = @task.slug

    updated_task_title = 'updated task title'
    @task.update!(title: updated_task_title)

    assert_equal updated_task_title, @task.title
    assert_equal task_slug, @task.slug
  end

  def test_slug_to_be_reused_after_getting_deleted
    first_task = Task.create!(title: 'test task', user: @user)
    second_task = Task.create!(title: 'test task', user: @user)

    second_task_slug = second_task.slug
    second_task.destroy
    new_task_with_same_title = Task.create!(title: 'test task', user: @user)

    assert_equal second_task_slug, new_task_with_same_title.slug
  end
end
