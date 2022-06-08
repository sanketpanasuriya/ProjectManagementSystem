class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy

    has_many :projects, through: :taggings, source: :taggable, source_type: 'Project', dependent: :destroy
    has_many :tasks, through: :taggings, source: :taggable, source_type: 'Task', dependent: :destroy
    has_many :sprints, through: :taggings, source: :taggable, source_type: 'Sprints', dependent: :destroy
    has_many :issues, through: :taggings, source: :taggable, source_type: 'Issues', dependent: :destroy

    validates :tag_name, presence: :true
    enum type_of_lable: { Project: "Project", Task:"Task",
        Sprint:"Sprint",Issue:"Issue"}
end
