# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_paranoid
  belongs_to :creator, class_name: 'User'
  belongs_to :client, class_name: 'User'
  has_many :sprints, class_name: 'Sprint', dependent: :destroy
  has_many :tags ,:as => :label
  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_status
    ]
  )

  scope :search_query, ->(query) {
    return nil  if query.blank?
    Project.where('lower(projects.description) LIKE :search OR lower(projects.name) LIKE :search', search: "%#{query.downcase}%")
  }

  scope :with_status, ->(status) {
    if(status == "overdue")
      where("endingdate < '#{Time.now}' and status!='completed'")
    else
      where(:status => [status])
    end
  }

  scope :sorted_by, ->(sort_option) {
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    projects = Project.arel_table
    tasks = Task.arel_table
    case sort_option.to_s
    when /^name_/
      order(projects[:name].lower.send(direction))
    when /^created_at_/
      order(projects[:created_at].send(direction))
    when /^endingdate/
      order(projects[:endingdate].send(direction))
    when /^updated_at/
      order(projects[:updated_at].send('desc'))
    when /^task/
      Project.joins(sprints: :tasks).group("projects.id").order('COUNT(project_id) asc')
      # Project.where(id:ids)
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Project start date', 'created_at_asc'],
      ['Project End date', 'endingdate'],
      ['Last Modified', 'updated_at'],
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
