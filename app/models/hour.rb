# frozen_string_literal: true

class Hour < ApplicationRecord
  belongs_to :task, class_name: 'Task'
end
