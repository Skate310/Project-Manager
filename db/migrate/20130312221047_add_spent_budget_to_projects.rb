class AddSpentBudgetToProjects < ActiveRecord::Migration
  def change
      add_column :projects, :spent_budget, :decimal, :precision => 15, :scale => 2
  end
end
