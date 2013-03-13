class CreateProjectsUsersJoin < ActiveRecord::Migration
  def up
      create_table 'projects_users', :id => false do |t|
        t.column 'project_id', :integer
        t.column 'user_id', :integer
      end
  end

  def down
    drop_table 'projects_users'
  end
end
