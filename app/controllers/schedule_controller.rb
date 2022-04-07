# frozen_string_literal: true

class ScheduleController < ApplicationController
  def index
    @status = { 'Created' => 'dark', 'On Going' => 'primary', 'Submitted' => 'secondary', 'Re-Submitted' => 'warning',
                'Rejected' => 'danger', 'Done' => 'success' }
    start_date = params.fetch(:start_date, Date.today).to_date
    created_at = Task.order(due_date: :desc).first.created_at
    @tasks_created = Task.where(created_at: created_at.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
end
