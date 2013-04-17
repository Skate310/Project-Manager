class Project < ActiveRecord::Base
    attr_accessible :deadline, :description, :end_date, :name, :start_date, :completion, :user_ids, :budget, :spent_budget
    validates_numericality_of :budget, :greater_than_or_equal_to => :spent_budget
    validates_numericality_of :spent_budget
    has_and_belongs_to_many :users
    has_many :tasks
    
    def self.search(search)
        if search
            where('name LIKE ?', "%#{search}%")
        else
            scoped
        end
    end
end
