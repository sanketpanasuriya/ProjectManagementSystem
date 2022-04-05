# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_paranoid
  belongs_to :creator, class_name: 'User'
  belongs_to :client, class_name: 'User'
  has_many :sprints, class_name: 'Sprint', dependent: :destroy
end
