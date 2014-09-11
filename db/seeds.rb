# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


cummings = [
   "John",
   "Maeve",
   "Mike",
   "Nuala",
   "Ciaran",
   "Shannon",
   "Aileen",
   "Justin",
   "Brendan",
   "Deirdre",
   "Anon"
  ]

johns = [
  "John2",
  "John3",
  "John4",
  "John5",
  "John6"
] 

users = cummings + johns

users.each do |user|
  u = User.create()
  auth = Auth.new(provider: "santa",
              name: user,
              user_id: u.id,
              email: "#{user}@example.com",
              password: "password",
              password_confirmation: "password"
              )
  auth.save
end

selection_date = Time.new(2014, 11, 30).to_date
open_date = Time.new(2014, 12, 25).to_date

cummings_group = Group.create({ name: "Cummings Family",
                               owner_id: User.first.id,
                               select_date: selection_date,
                               open_date: open_date
                                })

johns_group = Group.create({ name: "John Group", 
                             owner_id: User.first.id,
                             select_date: selection_date,
                             open_date: open_date
                              })

(1..cummings.length).each { |u| Membership.create(user_id: u, group_id: cummings_group.id) }
(cummings.length+1..users.length).each { |u| Membership.create(user_id: u, group_id: johns_group.id) }
Membership.create(user_id: 1, group_id: johns_group.id)
Gift.pull_from_hat date: selection_date