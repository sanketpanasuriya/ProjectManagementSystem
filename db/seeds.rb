# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
admin_role = Role.create(name: 'admin')
admin_user = User.create(name: 'Admin', email: 'admin@admin.com', password: '12345678',
                         password_confirmation: '12345678')
p admin_user.save!
p admin_role.save!
admin_user.add_role('admin')
