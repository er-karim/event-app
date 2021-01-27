class CreateGroupEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :group_events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.integer :duration
      t.date :start_at
      t.boolean :is_draft, default: true, null: true
      t.boolean :is_deleted, default: false, null: false

      t.timestamps
    end
  end
end
