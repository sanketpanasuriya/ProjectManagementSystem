# frozen_string_literal: true

class Issue < ApplicationRecord
  acts_as_paranoid
  belongs_to :project, class_name: 'Project'
  belongs_to :creator, class_name: 'User'
  belongs_to :employee, class_name: 'User', optional: true
end
