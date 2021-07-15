class TaskLoggerJob < ApplicationJob
  sidekiq_options queue: :default, retry: 3 # this option is only available with sidekiq versions >=6.0.1
  queue_as :default

  def perform(task)
    log = Log.create! task_id: task.id, message: "A task was created with the following attributes :: #{task.attributes}"
    puts log.message
  end
end
