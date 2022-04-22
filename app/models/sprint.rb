# frozen_string_literal: true

class Sprint < ApplicationRecord
  acts_as_paranoid
  belongs_to :project, class_name: 'Project'
  has_many :tasks, class_name: 'Task', dependent: :destroy


  filterrific(
    default_filter_params: { sprint_sorted_by: 'name_asc' },
    available_filters: [
      :sprint_sorted_by,
      :sprint_search_query,
      :with_sprint_status
    ]
  )

  scope :sprint_search_query, ->(query) {
    return nil  if query.blank?
    Sprint.where('lower(sprints.description) LIKE :search OR lower(sprints.title) LIKE :search', search: "%#{query.downcase}%")
  }

  scope :with_sprint_status, ->(status) {
    sprint_id = Task.where("tasks.status != 'Done'").select("tasks.sprint_id").map(&:sprint_id).uniq
    case status
      when /^overdue/
        where("sprints.expected_end_date <  '#{Time.now}'")
      when /^completed/
        where(id: sprint_id).invert_where
      when /^ongoing/
        where(id: sprint_id)
      else
        raise(ArgumentError, "Invalid status option: #{status.inspect}")
      end
  }


  scope :sprint_sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    sprints = Sprint.arel_table
    case sort_option.to_s
      when /^name_/
        order(sprints[:title].send(direction))
      when /^created_at_/
        order(sprints[:created_at].send(direction))
      when /^expected_end_date/
        order(sprints[:expected_end_date].send(direction))
      when /^updated_at_/
        order(sprints[:updated_at].send(direction))
      when /^task/
        joins(:tasks).group("sprints.id").order('COUNT(sprints.id) asc')
      else
        raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Sprint start date', 'created_at_asc'],
      ['Sprint End date', 'expected_end_date'],
      ['Last Modified', 'updated_at_desc'],
      ['Tasks', 'task']
    ]
  end

  def self.options_for_with_status
    [
      ['Completed', 'completed'],
      ['On Going', 'ongoing'],
      ['Over Due', 'overdue']
    ]
  end
end
