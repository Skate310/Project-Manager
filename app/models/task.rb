class Task < ActiveRecord::Base
    attr_accessible :completion, :deadline, :description, :end_date, :name, :start_date, :user_ids, :spent, :project_id
    validates_numericality_of :spent
    has_and_belongs_to_many :users
    belongs_to :project
    
    def start_time
      deadline.to_datetime
    end
    
    def self.search(search)
        if search
            where('name LIKE ?', "%#{search}%")
        else
            scoped
        end
    end
end
