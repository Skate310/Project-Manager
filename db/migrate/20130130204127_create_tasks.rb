class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.boolean :completion
      t.date :start_date
      t.date :end_date
      t.date :deadline

      t.timestamps
    end
  end
end
