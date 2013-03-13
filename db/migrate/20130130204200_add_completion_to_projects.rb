class AddCompletionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :completion, :boolean
    change_column :projects, :description, :text
  end
end
