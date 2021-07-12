class TasksController < ApplicationController
  before_action :authenticate_user_using_x_auth_token
  before_action :load_task, only: %i[show update destroy]

  def index
    tasks = Task.all
    render status: :ok, json: { tasks: tasks }
  end

  def create
    @task = Task.new(task_params.merge(creator_id: @current_user.id))
    if @task.save
      render status: :ok, json: { notice: t('successfully_created', entity: 'Task') }
    else
      errors = @task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def show
    render status: :ok, json: { task: @task, task_creator: User.find(@task.creator_id).name, assigned_user: User.find(@task.user_id) }
  end

  def update
    if @task.update(task_params)
      render status: :ok, json: { notice: t('successfully_updated', entity: 'Task') }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages.to_sentence }
    end
  end

  def destroy
    if @task.destroy
      render status: :ok, json: { notice: t('successfully_deleted', entity: 'Task') }
    else
      render status: :unprocessable_entity, json: { errors: @task.errors.full_messages.to_sentence }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :user_id)
  end

  def load_task
    @task = Task.find_by_slug!(params[:slug])
    puts "Task: ", @task
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e }
  end
end
