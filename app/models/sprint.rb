# frozen_string_literal: true

class Sprint < ApplicationRecord
  belongs_to :project, class_name: 'Project'
  has_many :tasks, class_name: 'Task'
end
