# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :creator_projects, class_name: 'Project', foreign_key: 'creator_id'
  has_many :client_projects, class_name: 'Project', foreign_key: 'client_id'
  has_many :taks, class_name: 'Task'
end
