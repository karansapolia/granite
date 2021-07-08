class MakeSlugNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :slug, false
  end
end
