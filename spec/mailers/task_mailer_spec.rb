# frozen_string_literal: true

require 'rails_helper'

describe LetterMailer do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, author_id: user.id) }

  describe 'check_overdue_letters' do
    # рассылка исполнителям о просроченных письмах
    let(:mail) { TaskMailer.check_overdue_tasks(task, task.author.email) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: не исполнена Задача #{task.id}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains task\'s name' do
      expect(mail.body.encoded).to match(task.name)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('которая не исполнена в срок!')
    end
  end

  describe 'soon_deadline_tasks' do
    # рассылка исполнителям о наступлении срока исполнения письма
    let(:mail) { TaskMailer.soon_deadline_tasks(task, task.author.email, 5, user) }
    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: 5 дн. на Задачу #{task.id}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains task\'s name' do
      expect(mail.body.encoded).to match(task.name)
    end
  end
end
