class Project < ApplicationRecord
    belongs_to :creator, class_name: "User"
    belongs_to :client, class_name: "User"
    has_many :sprints, class_name: "Sprint"
end
