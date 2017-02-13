Business Processes First Step (BP1Step)
---
Business processes documentation organization and generation, the 1st step of introduction of the processes approach in the small business

##General Information
**BP1Step** - первый шаг на небольшом предприятии для наведения порядка в процессах и повышения уровня зрелости организации.

**BP1Step** - простой инструмент для документирования процессов, ресурсов, действий сотрудников, это web-приложение на базе Ruby on Rails с несколькими сервисными rake-задачами (например: синхронизация списка пользователей из LDAP, контроль бизнес-правил).
Аутентификация пользователей с помощью Devise, ограничения ролей доступа на базе CanCanCan.

[![Build Status](https://travis-ci.org/RobBikmansurov/bp1step.svg?branch=master)](https://travis-ci.org/RobBikmansurov/bp1step)
[![build status](https://gitlab.com/RobBikmansurov/bp1step/badges/master/build.svg)](https://gitlab.com/RobBikmansurov/bp1step/commits/master)
[![Code Climate](https://codeclimate.com/github/RobBikmansurov/bp1step/badges/gpa.svg)](https://codeclimate.com/github/RobBikmansurov/bp1step)
[![Test Coverage](https://codeclimate.com/github/RobBikmansurov/bp1step/badges/coverage.svg)](https://codeclimate.com/github/RobBikmansurov/bp1step/coverage)

Язык: русский

Автор: [Rob Bikmansurov](mailto:robb@mail.ru)

Сайт: [bp1step.ru] (http://bp1step.ru)

Demo: [bp1step.herokuapp.com](https://bp1step.herokuapp.com/about) - без входа в систему будет доступен не весь функционал, поэтому смотрите список сотрудников в меню Сотрудники, выбирайте понравившегося и вводите, например, **ivanov@example.com**  в качестве логина и **ivanov** в качестве пароля.

Это приложение внедрено и работает, вот информация о статистике: 
![bp1step статистика](https://cloud.githubusercontent.com/assets/847150/20169830/d3917074-a753-11e6-814f-10d699d069e0.png)

---
Все понимают, что надо наводить порядок в процессах на предпрятии, внедрять процессный подход в организации, выделять и документировать процессы.
Но часто не знают с чего начать, пробуют перебирать различные сложные системы, рисовать диаграммы потоков работ и данных, упираются в сложность инструментов и бросают это важное дело.

Мы предлагаем начать с самого простого и **сделать первый шаг**.

Вам все равно не избежать работ по приведению в порядок имеющихся документов, выделению процессов и ресурсов (ролей, рабочих мест, приложений).
**BP1Step** поможет Вам выделить процессы и ресурсы, удобно вести их каталоги.
По каждому процессу можно увидеть связанные с ним документы, подпроцессы, роли, рабочие места, сотрудников.

Сотрудник, который является исполнителем в процессе, легко сможет ознакомиться с документацией процессов, в которых он участвует.

### Итак, с чего начать и что делать?

1. **Составить каталог Процессов**
Начните выделять процессы и вести их в виде иерархического дерева. Для каждого процесса определите наименование, обозначение, цель процесса, владельца процесса, кратко опишите последовательность действий. Если уже готовы - начните выделять роли исполнителей в данном процессе. **BP1Step** поможет Вам легко вести списки, вносить в них изменения. Сводная информация по процессу может быть получена в виде Карточки процесса.

2. **Составить каталог Ролей**
Осознали и выделили процессы - начните выделять бизнес-роли (группы действий).

3. **Составить каталог Документов**
Начните вести Каталог документов, относящихся к каждому процессу. Потом Вам проще будет вносить изменения в документы процесса.

4. **Составить каталог Рабочих мест, Приложений, Информационных ресурсов**
Просто перечислите все рабочие места, на которых исполнители выполняют роли, участвуя в процессе. Составьте каталог приложений и информационных ресурсов (каталоги, папки, базы данных, хранилища).

Ваша **цель** - понять что делается на предприятии и начать работу по **улучшению процессов**.

###Права доступа

Объем доступа задается ролями, у пользователя может быть несколько ролей:

*  Администратор доступа - ведение прав доступа пользователей, настройка системы

*  Администратор - ведение списков рабочих мест и приложений, настройка системы

*  БизнесАналитик - ведение списка процессов, документов, ролей, рабочих мест, приложений

*  ВладелецПроцесса - ведение документов, ролей, приложений, рабочих мест процесса, назначение исполнителей на роли

*  Автор - ведение документов и директив, удаление своих документов

*  Исполнитель - просмотр информации по исполняемым ролям, участию в процессах, комментирование документов процесса

*  Хранитель - отвечает за хранение бумажных оригиналов, изменяет место хранения документа или договора

##Getting Started#

>sudo apt-get install unoconv

Загрузите проект 

>git clone https://github.com/RobBikmansurov/BPDoc

>cd BPDoc

Настройте доступ к БД, в тестовом примере используется SQLite3.
Достаточно просто скопировать config/database.yml.example в config/database.yml

>cp config/database.yml{.example,} 

Замечу, что при использовании SQLite не будет работать поиск и
autocomlete. Для решения этой проблемы можно исправить команды SQL ILIKE на LIKE в методах autocomplete в контроллерах и search в моделях.

Например в app/models/user.rb:

      where('username ILIKE ? or displayname ILIKE ?', "%#{search}%", "%#{search}%")

заменить на:

      where('username LIKE ? or displayname LIKE ?', "%#{search}%", "%#{search}%")


>bundle install

Для работы с пользователями, хранящими пароли в БД необходимо выполнить скрипт

>./db.auth.on

>rake db:setup

>rake db:seed

>rails g public_activity:migration

>rake db:migrate

>rails s

Далее в браузере http://localhost:3000

##Testing#
Пока есть тесты только для моделей

>rspec spec/models/

## Contributing

1. Fork it ( https://github.com/[my-github-username]/storage/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

##License#
MIT
 see in LICENSE file.

 Copyright &copy; 2012-2015 Rob Bikmansurov. All rights reserved.
 
 Author: Rob Bikmansurov, contacts: robb@mail.ru


 [Rob Bikmansurov](mailto:robb@mail.ru)
