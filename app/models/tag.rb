class Tag < ApplicationRecord
    belongs_to :label, :polymorphic =>true, optional: true
    validates :tag_name, presence: :true
    enum type_of_lable: { Project: "Project", Task:"Task",
        Sprint:"Sprint",Issue:"Issue",Project:"Project"}
end
