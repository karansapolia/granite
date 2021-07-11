class TasksController < ApplicationController
  before_action :load_task, only: [:show]

  def index
    tasks = Task.all
    render status: :ok, json: { tasks: tasks }
  end

  def create
    task = Task.new(task_params)
    if task.save
      render status: :ok, json: { notice: t('successfully_created') }
    else
      errors = task.errors.full_messages.to_sentence
      render status: :unprocessable_entity, json: { errors: errors }
    end
  end

  def show
    puts "task: ", @task
    render status: :ok, json: { task: @task }
  end

  private

  def task_params
    params.require(:task).permit(:title)
  end

  def load_task
    @task = Task.find_by_slug!(params[:slug])
    puts "Task: ", @task
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e }
  end
end
