# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# access roles
["admin", "analitic", "owner", "autor", "user"].each do |name|
  Role.create!(:name => name, :description => name + ' role')
end

# users
#user1 = User.create(:displayname => 'Иванов И.И.', :username => 'ivanov', :email => 'ivanov@example.com', :password => 'topsecret')

# applications
['Office', 'Notepad', "Excel", 'Word', 'Powerpoint'].each do |name |
	Bapp.create(:name => name,
				:description => 'Microsoft ' + name + ' 2003',
				:apptype => 'офис',
				:purpose => 'редактирование ' + name)
end
ap1 = Bapp.create(:name => '1С:Бухгалтерия', :description => '1С:Бухгалтерия. Учет основных средств', :apptype => 'бух')

# workplaces
wp1 = Workplace.create(:name => 'РМ УИТ Начальник', :description => "начальник УИТ", :designation => 'РМУИТНачальник', :location => '100')
wp2 = Workplace.create(:name => 'Главный бухгалтер', :description => "Главный бухгалтер", :designation => 'РМГлБухгалтер', :location => '200')
["Кассир", "Бухгалтер", "Контролер", "Юрист", "Экономист"].each do |name|
	3.times do |n|
		n += 1
		Workplace.create(:name => 'РМ ' + name,
						 :description => 'рабочее место' + name,
						 :designation => name + n.to_s,
						 :location => n.to_s + '01')
  	end
end
