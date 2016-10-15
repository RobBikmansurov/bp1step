require "spec_helper"

describe LetterMailer do
  describe 'рассылка исполнителям о просроченных письмах' do
    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @letter = Letter.new(number: '1', date: DateTime.current)
      LetterMailer.check_overdue_letters(@letter, ["your-blog@no-reply.com"])   # рассылка исполнителям о просроченных письмах.deliver
    end

    it 'should send an email' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end
    it 'returns correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq "BP1Step: не исполнено Письмо #{@letter.name}"
    end
    it 'returns correct from email' do
      expect(ActionMailer::Base.deliveries.first.from).to eq ["your-blog@no-reply.com"]
    end
  end
end