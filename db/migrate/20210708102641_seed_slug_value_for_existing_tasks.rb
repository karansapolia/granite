class SeedSlugValueForExistingTasks < ActiveRecord::Migration[6.0]
  def up
    Task.find_each do |task|
      task.send(:set_slug)
      task.save(validate: false)
    end
  end

  def down
    Task.find_each do |task|
      task.update(slug: nil)
      task.save(validate: false)
    end
  end
end
