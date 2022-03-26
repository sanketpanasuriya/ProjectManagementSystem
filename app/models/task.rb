# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :sprint, class_name: 'Sprint'
  belongs_to :user, class_name: 'User'

  validates :title, :sprint_id, :user_id, :due_date, :status, :description, presence: true
  validates_each :due_date do |records, attrs, value|
    records.errors.add(attrs, "Must after todays date") unless value > Time.now
  end

  private
  def check_date
    self.due_date > Time.now
  end
end
