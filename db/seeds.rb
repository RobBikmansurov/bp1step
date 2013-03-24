# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

PublicActivity.enabled = false
# access roles
["admin", "analitic", "owner", "author", "user", "writer"].each do |name|
  Role.create!(:name => name, :description => name + '_role')
end
puts "roles created"

# users
user1 = User.create(:displayname => 'Иванов И.И.', :username => 'ivanov', :email => 'ivanov@example.com', :password => 'ivanov')
user2 = User.create(:displayname => 'Петров П.П.', :username => 'petrov', :email => 'petrov@example.com', :password => 'petrov')
user3 = User.create(:displayname => 'Администратор', :username => 'admin1', :email => 'admin1@example.com', :password => 'admin1')
puts "users created"

# applications
['Office', 'Notepad', "Excel", 'Word', 'Powerpoint'].each do |name |
	Bapp.create(:name => name,
				:description => 'Microsoft ' + name + ' 2003',
				:apptype => 'офис',
				:purpose => 'редактирование ' + name)
end
ap1 = Bapp.create(:name => '1С:Бухгалтерия', :description => '1С:Бухгалтерия. Учет основных средств', :apptype => 'бух')
puts "applications created"

# workplaces
wp1 = Workplace.create(:name => 'РМ УИТ Начальник', :description => "начальник УИТ", :designation => 'РМУИТНачальник', :location => '100')
wp2 = Workplace.create(:name => 'Главный бухгалтер', :description => "Главный бухгалтер", :designation => 'РМГлБухгалтер', :location => '200')
["Кассир", "Бухгалтер", "Контролер", "Юрист", "Экономист"].each do |name|
	3.times do |n|
		n += 1
		Workplace.create(:name => 'РМ ' + name + n.to_s,
						 :description => 'рабочее место' + name + n.to_s,
						 :designation => name + n.to_s,
						 :location => n.to_s + '01')
  	end
end
puts "workplaces created"

PublicActivity.enabled = true