# encoding: utf-8

PublicActivity.enabled = false
# access roles
Role.destroy_all
Role.create!(:note => 'Просмотр информации по исполняемым ролям, участию в процессах, комментирование документов процесса', :name => 'user', :description => 'Исполнитель')
Role.create!(:note => 'Ведение документов, ролей, приложений, рабочих мест процесса, назначение исполнителей на роли', :name => 'owner', :description => 'Владелец процесса')
Role.create!(:note => 'Ведение списка процессов, документов, ролей, рабочих мест, приложений', :name => 'analitic', :description => 'Бизнес-аналитик')
Role.create!(:note => 'Ведение списков рабочих мест и приложений, настройка системы', :name => 'admin', :description => 'Администратор')
Role.create!(:note => 'Ведение документов и директив, удаление своих документов', :name => 'author', :description => 'Автор')
Role.create!(:note => 'Отвечает за хранение бумажных оригиналов, изменяет место хранения документа', :name => 'keeper', :description => 'Хранитель')
Role.create!(:note => 'Ведение прав пользователей, настройка системы', :name => 'security', :description => 'Администратор доступа')
Role.create!(:note => 'Управляет пользователями: прикрепляет документы в Обязательное ', :name => 'manager', :description => 'Менеджер')
Role.create!(:note => 'Создает и регистрирует письма', :name => 'secretar', :description => 'Секретарь')

puts "access roles created"
Role.all.pluck(:name)
puts
# users
User.destroy_all
user1 = User.create(displayname: 'Иванов И.И.', username: 'ivanov', email: 'ivanov@example.com', password: 'ivanov',
	                 firstname: 'Иван', middlename: 'Иванович', lastname: 'Иванов', office: '101', position: 'Экономист',
	                 phone: '+7(342)212-34-56')
user1.roles << Role.find_by_name(:author)
user1.roles << Role.find_by_name(:analitic)
user1.roles << Role.find_by_name(:owner)
user2 = User.create(:displayname => 'Петров П.П.', :username => 'petrov', :email => 'petrov@example.com', :password => 'petrov', firstname: 'Петр', middlename: 'Петрович', lastname: 'Петров')
user2.roles << Role.find_by_name(:author)
user3 = User.create(:displayname => 'Администратор', :username => 'admin1', :email => 'admin1@example.com', :password => 'admin1')
user3.roles << Role.find_by_name(:admin)
user3.roles << Role.find_by_name(:security)
user4 = User.create(displayname: 'Сидоров С.С.', username: 'sidorov', email: 'sidorov@example.com', password: 'sidorov', firstname: 'Сидор', middlename: 'Сидорович', lastname: 'Сидоров')
user4.roles << Role.find_by_name(:author)
user5 = User.create(displayname: 'Путин В.В.', username: 'putinx', email: 'putinx@example.com', password: 'putinx', department: 'Библиотека', position: 'Юрист', office: '201', phone: '2201')
user5.roles << Role.find_by_name(:keeper)
user5.roles << Role.find_by_name(:user)
user6 = User.create(:displayname => 'Кудрин А.В.', :username => 'kudrin', :email => 'kudrin@example.com', :password => 'kudrin', position: 'Финансист')
user6.roles << Role.find_by_name(:author)
user6.roles << Role.find_by_name(:owner)
user6.roles << Role.find_by_name(:analitic)
user6.roles << Role.find_by_name(:security)
user7 = User.create(displayname: 'Яровая И.Й.', username: 'shapoklyak', email: 'shapoklyak@example.com',
	password: 'shapoklyak', phone: '8-800-0001234', position: 'старший менеджер')
user7.roles << Role.find_by_name(:secretar)
user7.roles << Role.find_by_name(:author)
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

ir1 = Iresource.create(level: 'DB', label: '1С.УчетОС', note: '1С.Учет основных средств', location: "//srv/data/1C/OC", volume: 1)
ir1.user_id = user1.id
ir1.save
puts "iresources created"

d = Document.create(name: 'Положение об оплате счетов', status: 'Утвержден', dlevel: 2, place: 'Бух.Папка1', approved: '2015-01-01', approveorgan: 'Правление')
d.owner_id = user2.id
d.save
d.bproce_document.create(bproce_id: bp14.id, purpose: '???')
d = Document.create(name: 'Устав', status: 'Утвержден', dlevel: 2, place: 'Сейф1', approved: '2015-01-01', approveorgan: 'Собрание акционеров')
d.owner_id = user4.id
d.save

puts 'documents created'

ag1 = Agent.create(name: 'ООО 1С в помощь', town: 'Урюпинск', address: '123000. г.Урюпинск, ул.Ленина,2-101', contacts: 'Оля, +7(900)1234567')
ag2 = Agent.create(name: 'ООО Рога и копыта', town: '', address: '614000. г.Сыктывкар, ул.Ленина, 1', contacts: 'info@example.com')
12.times.map do |i|
	Agent.create!(name: ['ООО "Развитие"', 'ПАО "Газпромбанк"', 'ОАО "Открытые технологии"', 'ИП Иванов Иван Иванович', 'ООО "1С"',
	  'ООО "Вектор Плюс"', 'ИП Петров Петр Петрович', 'ООО "Строитель"', 'ОАО "Коммунальщик-3"', 'ПАО "Сетевая компания"',
	  'ООО "Кудесник"', 'АО "Жилищник ХЗ"'][i],
	  shortname: ['Развитие', 'Газпромбанк', 'Открытые технологии', 'Иванов И.И.', '1С',
	  'Вектор+', 'Петров П.П.', 'Строитель', 'Коммунальщик-3', 'Сетевая компания',
	  'Кудесник', 'Жилищник'][i],
	  town: ['Пермь', 'Сочи', 'Москва', 'Екатеринбург', 'Орел'][rand(5)],
	  address: ['ул.', 'пл.', 'пр.'][rand(3)] + ['Ленина', 'Ильича', 'Московская', 'Ульянова', 'Коммунизма'][rand(5)] + ", д.#{rand(200)}",
	  contacts: "тел. +7 (#{rand(999)}) #{rand(9999)}-#{rand(999)}"
	)
end
puts 'agents created'

co = Contract.new(number: '2-2014', name: 'предоставления услуг', status: 'Действует',
	date_begin: Date.current - 6.month, text: 'text', contract_type: 'Договор', description: 'о предоставлении услуг связи')
co.agent_id = ag2.id
co.owner_id = user1.id
co.payer_id = user2.id
co.save
co = Contract.new(number: '1', name: 'оказания услуг', status: 'Действует',
	date_begin: Date.current - 1.year, text: 'text', contract_type: 'Договор', description: 'о технической поддержке')
co.agent_id = ag1.id
co.owner_id = user3.id
co.payer_id = user2.id
co.save
co = Contract.new(number: '3', name: 'оказания услуг', status: 'Согласование',
	date_begin: Date.current , text: 'text', contract_type: 'Договор', description: 'поставки')
co.agent_id = ag1.id
co.owner_id = user3.id
co.save
puts 'contracts created'

m = Metric.create(name: 'ИнцидентовВсего', description: 'количество инцидентов, зарегистрированных в системе', depth: '3', bproce_id: bp211.id)
puts "metrics created"

di = Directive.create(title: 'Положение', number: '123-П', approval: Date.current - 1.month,
  name: 'Краткий порядок управления финансами',
	status: 'Действует', body: 'ЦБ РФ', note: 'Об управлении финансами')
dd = di.document_directive.create(document_id: d.id)
di = Directive.create(title: 'Основной закон', number: '00', approval: '2011-09-11', name: 'Конституция',
  status: 'Действует', body: 'РФ', note: 'Основной и самый главный')
dd = di.document_directive.create(document_id: Document.last.id)
p "directives created"


l1 = Letter.create(number: "12-34/123", date: Date.current - 10, subject: "о предоставлении информации", source: "фельдпочта",
	               sender: "Администрация президента", body: "срочно предоставить", duedate: Date.current - 1, author: user7,
	               status: 5)
l1.user_letter.create(user_id: user5.id, status: 1)
l1.user_letter.create(user_id: user6.id)
l1 = Letter.create(number: "99/2", date: Date.current - 1.month, subject: "о согласовании митинга", source: "курьер",
	               sender: "ФБК", body: "хотят согласовать", duedate: Date.current - 20, author: user7,
	               status: 5)
l1.user_letter.create(user_id: user2.id, status: 1)
l1.user_letter.create(user_id: user3.id)
puts 'Letters created'

r = Requirement.create(label: "Напрячься и предоставить информацию!", date: Date.current - 5, duedate: Date.current,
                        body: "товарищи, надо собраться и сделать", status: 0, letter_id: l1.id, author: user5)
r.user_requirement(user_id: user5.id, requirement_id: r.id, status: 1)

puts 'Requirements created'

t1 = Task.create(name: "Напрячься срочно и сильно", description: "Очень важно сделать это усилие.\r\nСрочно и быстро и резко.\r\nВ едином порыве",
                 duedate: Date.current - 3, requirement_id: r.id, author: user6, status: 5)
t1.user_task.create(user_id: user4.id)
t2 = Task.create(name: "предоставить", description: "Всем вместе взять и предоставить.\r\nДо единого гвоздя, нежно и в тему",
                 duedate: Date.current, requirement_id: r.id, author: user2, status: 50)
t2.user_task.create(user_id: user2.id)
puts 'Tasks created'

PublicActivity.enabled = true


+#<Directive id: 173, title: "Указ", number: "1009", approval: "2004-08-04", name: " Об утверждении перечня стратегических предприятий и стратегических акционерных обществ", note: "", body: "Президент РФ", created_at: "2015-03-26 07:51:41", updated_at: "2015-03-26 09:04:56", annotation: "", status: "Действует", action: nil>
+#<Directive id: 120, title: "Стандарт", number: "1.0-2014", approval: "2014-06-01", name: "Стандарт Банка России СТО БР ИББС-1.0–2014 “Обеспе...", note: "Взамен СТО БР ИББС 1.0-2010", body: "Банк России", created_at: "2014-06-03 04:32:19", updated_at: "2014-10-16 09:54:01", annotation: "", status: "Действует", action: nil>
+
+ Стандарт Банк России № 1.0-2014 от 01.06.2014 "Действует"
+Стандарт Банка России СТО БР ИББС-1.0–2014 “Обеспечение информационной безопасности организаций банковской системы Российской Федерации. Общие положения»
+примечание: Взамен СТО БР ИББС 1.0-2010
+ Постановление Правительство РФ № 1119 от 01.11.2012 "Действует"
+Об утверждении требований к защите персональных данных при их обработке в информационных системах персональных данных
+ Постановление РФ № №1137 от 26.12.2011
+О формах и правилах заполнения (ведения)документов, применяемых при расчетах по налогу на добавленную стоимость
+примечание: см. редакцию с последними изменениями
+ Федеральный закон Государственная Дума № 129-ФЗ от 08.08.2001 "Действует"
+"О государственной регистрации юридических лиц и индивидуальных предпринимателей"
+примечание: Для Банка актуален вопрос раскрытия информации в ЕФРС, который определен данным законом (Статья 7.1.).

