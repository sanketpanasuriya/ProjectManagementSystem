# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  cattr_reader :current_password
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :creator_projects, class_name: "Project", foreign_key: "creator_id", dependent: :destroy
  has_many :client_projects, class_name: "Project", foreign_key: "client_id", dependent: :destroy
  has_many :taks, class_name: "Task", dependent: :destroy
  def update_with_password(user_params)
    current_password = user_params.delete(:current_password)

    if self.valid_password?(current_password)
      self.update(user_params)
      true
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end
  end
end
