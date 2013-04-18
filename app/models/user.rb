class User < ActiveRecord::Base
    attr_accessible :email, :expertise, :password, :password_confirmation, :phone_number, :role, :first_name, :last_name, :project_ids, :task_ids
    has_secure_password
    validates_presence_of :email, :password, :first_name, :last_name, :on => :create
    validates_uniqueness_of :email
    has_and_belongs_to_many :projects
    has_and_belongs_to_many :tasks
    
    def name
      "#{first_name} #{last_name}"
    end
    
    def self.search(search)
        if search
            where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}")
        else
            scoped
        end
    end
end
