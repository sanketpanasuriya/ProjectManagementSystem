class Hour < ApplicationRecord
    belongs_to :task, class_name: 'Task'
 
  
end
