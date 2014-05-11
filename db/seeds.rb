# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users =[
   "John",
   "Maeve",
   "Mike",
   "Nuala",
   "Ciaran",
   "Shannon",
   "Ailleen",
   "Justin",
   "Brendan",
   "Deirdre",
  ]

users.each do |user|
  u = User.new()
  u.save
  auth = Auth.new(provider: "santa",
              name: user,
              user_id: u.id,
              email: "#{user}@example.com",
              password: "password",
              password_confirmation: "password"
              )
  auth.save
end

group1 = Group.create(name: "Cummings Family",
                      owner_id: User.first.id)

cummings_ids = []
User.all.each {|u| cummings_ids << u.id }

group1.user_ids = cummings_ids
group1.save
