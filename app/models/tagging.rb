class Tagging < ApplicationRecord
    belongs_to :taggable, :polymorphic =>true, optional: true, dependent: :destroy
    belongs_to :tag, dependent: :destroy
end
