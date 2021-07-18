class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.integer :notification_delivery_hour
      t.boolean :receive_email, default: true, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
