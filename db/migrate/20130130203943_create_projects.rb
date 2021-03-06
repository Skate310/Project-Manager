class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date
      t.date :deadline

      t.timestamps
    end
  end
end
