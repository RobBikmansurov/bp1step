# frozen_string_literal: true

require 'rails_helper'

describe UserTaskMailer do
  include_examples 'creates a user task'

  describe 'user_task_create' do
    # рассылка о назначении исполнителя
    let(:mail) { described_class.user_task_create(user_task, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: Вы - отв.исполнитель Задачи ##{task.id}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(user.displayname)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('исполнителем </a>')
    end
  end

  describe 'user_task_destroy' do
    # рассылка об удалении исполнителя
    let(:mail) { described_class.user_task_destroy(user_task, user) }

    it 'renders correct subject' do
      expect(mail.subject).to eql("BP1Step: удален исполнитель Задачи ##{task.id}")
    end
    it 'renders the sender email' do
      expect(mail.from).to eql(['bp1step@bankperm.ru'])
    end
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    it '@text contains bproce\'s name' do
      expect(mail.body.encoded).to match(user.displayname)
    end
    it '@text contains text' do
      expect(mail.body.encoded).to match('удален из исполнителей Задачи')
    end
  end
end
