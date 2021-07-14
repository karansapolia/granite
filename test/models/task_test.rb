require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def test_instance_of_task
    task = Task.new

    assert_instance_of Task, task
  end

  def test_not_instance_of_user
    task = Task.new
    assert_not_instance_of User, task
  end

  def test_value_of_title_assigned
    task = Task.new(title: "Title assigned for testing")
    assert_equal "Title assigned for testing", task.title
  end

  def test_value_created_at
    task = Task.new(title: "This is a test task", user: @user)
    assert_nil task.created_at

    task.save!
    assert_not_nil task.created_at
  end
end
