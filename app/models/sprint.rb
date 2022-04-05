# frozen_string_literal: true

class Sprint < ApplicationRecord
  acts_as_paranoid
  belongs_to :project, class_name: 'Project'
  has_many :tasks, class_name: 'Task', dependent: :destroy
end
