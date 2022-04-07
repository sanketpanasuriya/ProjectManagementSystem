# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid
  belongs_to :sprint, class_name: 'Sprint'
  belongs_to :user, class_name: 'User'
  has_many :hours, class_name: 'Hour', dependent: :delete_all
  validates :title, :sprint_id, :user_id, :due_date, :status, :description, presence: true
  validates_each :due_date do |records, attrs, value|
    records.errors.add(attrs, 'Must after todays date') unless value > Time.now
  end
  after_save do |task|
    case task['status']
    when 'On Going'
      hours_creat = Hour.find_by(task_id: task['id'])
      if !hours_creat.nil?
        hours_creat.ending = nil
      else
        hours_creat = Hour.new
        hours_creat.starting = Time.now
        hours_creat.task = task
      end
      hours_creat.save!

    when 'Done'

      hours_creat = Hour.find_by(task_id: task['id'])

      unless hours_creat.nil?
        hours_creat.ending = Time.now
        hours_creat.save!
      end
    end
  end

  private

  def check_date
    due_date > Time.now
  end
end
