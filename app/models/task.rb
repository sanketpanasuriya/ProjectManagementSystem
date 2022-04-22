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

  filterrific(
    default_filter_params: { task_sorted_by: 'name_asc' },
    available_filters: [
      :task_sorted_by,
      :task_search_query,
      :with_task_status
    ]
  )

  scope :task_search_query, ->(query) {
    return nil  if query.blank?
    Task.where('lower(tasks.description) LIKE :search OR lower(tasks.title) LIKE :search', search: "%#{query.downcase}%")
  }

  scope :with_task_status, ->(status) {
    sprint_id = Task.where("tasks.status != 'Done'").select("tasks.sprint_id").map(&:sprint_id).uniq
    case status
      when /^overdue/
        where("tasks.due_date <  '#{Time.now}'")
      when status
        where(status: status)
      else
        raise(ArgumentError, "Invalid status option: #{status.inspect}")
      end
  }


  scope :task_sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    tasks = Task.arel_table
    case sort_option.to_s
      when /^name_/
        order(tasks[:title].send(direction))
      when /^created_at_/
        order(tasks[:created_at].send(direction))
      when /^due_date/
        order(tasks[:due_date].send(direction))
      when /^updated_at_/
        order(tasks[:updated_at].send(direction))
      else
        raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Task start date', 'created_at_asc'],
      ['Task End date', 'due_date'],
      ['Last Modified', 'updated_at_desc']
    ]
  end

  def self.options_for_with_status
    [
      ['Done', 'Done'],
      ['On Going', 'On Going'],
      ['Created', 'Created'],
      ['Submitted','Submitted'],
      ['Re-Submitted','Re-Submitted'],
      ['Rejected','Rejected'],
      ['Over Due', 'overdue']
    ]
  end

  private

  def check_date
    due_date > Time.now
  end
end
