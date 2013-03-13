class AddBudgetToProjects < ActiveRecord::Migration
  def change
      add_column :projects, :budget, :decimal, :precision => 15, :scale => 2
      add_column :tasks, :spent, :decimal, :precision => 15, :scale => 2
  end
end
