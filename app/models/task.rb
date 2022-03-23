# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :sprint, class_name: 'Sprint'
  belongs_to :user, class_name: 'User'
end
