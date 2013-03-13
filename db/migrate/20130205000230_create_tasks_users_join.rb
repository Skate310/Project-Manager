class CreateTasksUsersJoin < ActiveRecord::Migration
  def up
      create_table 'tasks_users', :id => false do |t|
        t.column 'task_id', :integer
        t.column 'user_id', :integer
      end
  end

  def down
    drop_table 'tasks_users'
  end
end
