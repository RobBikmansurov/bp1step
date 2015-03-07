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
Role.create!(:note => 'Просмотр информации по исполняемым ролям, участию в процессах, комментирование документов процесса', :name => 'user', :description => 'Исполнитель')
Role.create!(:note => 'Ведение документов, ролей, приложений, рабочих мест процесса, назначение исполнителей на роли', :name => 'owner', :description => 'Владелец процесса')
Role.create!(:note => 'Ведение списка процессов, документов, ролей, рабочих мест, приложений', :name => 'analitic', :description => 'Бизнес-аналитик')
Role.create!(:note => 'Ведение списков рабочих мест и приложений, настройка системы', :name => 'admin', :description => 'Администратор')
Role.create!(:note => 'Ведение документов и директив, удаление своих документов', :name => 'author', :description => 'Писатель')
Role.create!(:note => 'Отвечает за хранение бумажных оригиналов, изменяет место хранения документа', :name => 'keeper', :description => 'Хранитель')
Role.create!(:note => 'Ведение прав пользователей, настройка системы', :name => 'security', :description => 'Администратор доступа')

puts "access roles created"
Role.pluck(:name)

# users
user1 = User.create(:displayname => 'Иванов И.И.', :username => 'ivanov', :email => 'ivanov@example.com', :password => 'ivanov', firstname: 'Иван', middlename: 'Иванович', lastname: 'Иванов')
user1.roles << Role.find_by_name(:author)
user1.roles << Role.find_by_name(:analitic)
user1.roles << Role.find_by_name(:owner)
user2 = User.create(:displayname => 'Петров П.П.', :username => 'petrov', :email => 'petrov@example.com', :password => 'petrov')
user2.roles << Role.find_by_name(:author)
user3 = User.create(:displayname => 'Администратор', :username => 'admin1', :email => 'admin1@example.com', :password => 'admin1')
user3.roles << Role.find_by_name(:admin)
user3.roles << Role.find_by_name(:security)
user4 = User.create(:displayname => 'Сидоров С.С.', :username => 'sidorov', :email => 'sidorov@example.com', :password => 'sidorov')
user4.roles << Role.find_by_name(:author)
user5 = User.create(displayname: 'Путин В.В.', username: 'putinx', email: 'putinx@example.com', password: 'putinx', department: 'Библиотека', position: 'Юрист', office: '201', phone: '2201')
user5.roles << Role.find_by_name(:keeper)
user5.roles << Role.find_by_name(:user)
user6 = User.create(:displayname => 'Кудрин А.В.', :username => 'kudrin', :email => 'kudrin@example.com', :password => 'kudrin')
user6.roles << Role.find_by_name(:author)
user6.roles << Role.find_by_name(:owner)
user6.roles << Role.find_by_name(:analitic)
user6.roles << Role.find_by_name(:security)
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
		wp = Workplace.create(:name => 'РМ ' + name + n.to_s,
						 :description => 'рабочее место' + name + n.to_s,
						 :designation => name + n.to_s,
						 :location => n.to_s + '01')
 	end
end
3.times do |n|
	n += 1
	wp = Workplace.find(n+5)
	uwp = wp.user_workplace.create(date_from: '2015-01-11', date_to: '2015-12-31', note: ' ')
	u = User.find(n)
	uwp.user_id = u.id
	uwp.save
end
puts "workplaces created"

# terms
term = Term.create(:name => 'электронная подпись', :shortname => 'ЭП', source: 'договор на обслуживание в системе Банк-Клиент', 
					:description => 'Информация в электронной форме, которая присоединена к другой информации в электронной форме (подписываемой информации) или иным образом связана с такой информацией и которая используется для определения лица, подписывающего информацию')
term = Term.create(name: 'Авторизация', shortname: 'Авторизация',  description: 'Предоставление прав доступа')
term = Term.create(name: 'Аутентификация', shortname: 'Аутентификация',  description: 'Проверка принадлежности субъекту доступа предъявленного им идентификатора (подтверждение подлинности)')
term = Term.create(name: 'Идентификакция', shortname: 'Идентификакция',  description: 'Процесс присвоения идентификатора (уникального имени); сравнение предъявляемого идентификатора с перечнем присвоенных идентификаторов')
term = Term.create(name: 'Доступность информационных активов', shortname: 'Доступность',  description: 'Свойство информационных активов предоставлять доступ к ним в определенном виде, месте и время, необходимые авторизованному субъекту')
term = Term.create(name: 'Жизненный цикл', shortname: 'ЖЦ',  description: 'Период времени, который начинается с момента принятия решения о необходимости создания программного продукта и заканчивается в момент его полного изъятия из эксплуатации')
term = Term.create(name: 'Информационные технологии', shortname: 'ИТ',  description: 'Процессы, методы поиска, сбора, хранения, обработки, предоставления, распространения информации и способы осуществления таких процессов и методов')
term = Term.create(name: 'Информационный актив', shortname: 'ИА',  description: 'Информация с реквизитами, позволяющими ее идентифицировать; имеющая ценность для банка; находящаяся в его распоряжении и представленная на любом материальном носителе в пригодной для ее обработки, хранения или передачи форме')
term = Term.create(name: 'Несанкционированный доступ', shortname: 'НСД',  description: 'Доступ к информации или к ресурсам автоматизированной информационной системы, осуществляемый с нарушением установленных прав и (или) правил доступа')
term = Term.create(name: 'Нерегламентированные действия в рамках предоставленных полномочий', shortname: 'НРД',  description: 'Действия с информацией или ресурсами автоматизированной информационной системы, осуществляемый с нарушением установленных регламентов работы с ними с использованием служебного положения')
term = Term.create(name: 'Процесс', shortname: 'Процесс',  description: 'Совокупность взаимосвязанных ресурсов и деятельности, преобразующая входы в выходы')
term = Term.create(name: 'Ресурс', shortname: 'Ресурс',  description: 'Актив, который используется или потребляется в процессе выполнения некоторой деятельности')
term = Term.create(name: 'Актив', shortname: 'Актив', description: 'Все, что имеет ценность для банка и находится в его распоряжении')
puts 'terms created'

#processes
bp1 = Bproce.create(name: 'Предоставление сервисов', shortname: 'B.4.1', 
	fullname: 'Предоставление сервисов', user_id: 1)
bp1.user_id = user1.id
bp1.save
bp11 = Bproce.create(name: 'Управление уровнем сервисов', shortname: 'SLM', fullname: 'Управление уровнем сервисов', parent_id: bp1.id)
bp12 = Bproce.create(name: 'Управление мощностями', shortname: 'CAP', fullname: 'Управление мощностями', parent_id: bp1.id)
bp13 = Bproce.create(name: 'Управление непрерывностью', shortname: 'SCM', fullname: 'Управление непрерывностью', parent_id: bp1.id)
bp14 = Bproce.create(name: 'Управление финансами', shortname: 'FIN', fullname: 'Управление финансами', parent_id: bp1.id)
bp14.user_id = user1.id
bp14.save
bp14.business_roles.create(name: 'НачальникИТ', description: 'Контролирует счета, готовит План закупок')
br1 = bp14.business_roles.create(name: 'Бухгалтер', description: 'Оплачивает счет, учитывает бухгалтерские документы', features: 'Нужен калькулятор')
ubr1 = br1.user_business_role.create(date_from: '2015-01-11', date_to: '2015-12-31', note: 'исп.обязанности')
ubr1.user_id = user1.id
ubr1.save
bp15 = Bproce.create(name: 'Управление доступностью', shortname: 'AVA', fullname: 'Управление доступностью', parent_id: bp1.id)

bp2 = Bproce.create(name: 'Поддержка сервисов', shortname: 'B.4.2', fullname: 'Поддержка сервисов')
bp21 = Bproce.create(name: 'Управление инцидентами', shortname: 'INC', fullname: 'Управление инцидентами', parent_id: bp2.id)
bp211 = Bproce.create(name: 'Служба поддержки пользователей Service Desk', shortname: 'SD', fullname: 'Служба поддержки пользователей Service Desk', parent_id: bp21.id)
bp22 = Bproce.create(name: 'Управление проблемами', shortname: 'PRB', fullname: 'Управление проблемами', parent_id: bp2.id)
bp23 = Bproce.create(name: 'Управление конфигурациями', shortname: 'CFG', fullname: 'Управление конфигурациями', parent_id: bp2.id)
bp23 = Bproce.create(name: 'Управление релизами', shortname: 'REL', fullname: 'Управление релизами', parent_id: bp2.id)
bp23 = Bproce.create(name: 'Управление изменениями', shortname: 'CNG', fullname: 'Управление изменениями', parent_id: bp2.id, user_id: user6)

puts "processes created"

m = Metric.create(name: 'ИнцидентовВсего', description: 'количество инцидентов, зарегистрированных в системе', depth: '3', bproce_id: bp211.id)
puts "metrics created"

PublicActivity.enabled = true