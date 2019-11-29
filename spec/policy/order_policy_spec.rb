require 'rails_helper'

RSpec.describe OrderPolicy do
  subject { described_class.new }
  let(:user) { create :user }
  let(:author) { create :user}
  let(:manager) { create :user}
  let(:executor) { create :user}
  let(:order_created) { create :order, author_id: author.id, order_type: '123' }
  let(:order_approved) { create :order, author_id: author.id, manager_id: manager.id }
  let(:order_completed) { create :order, author_id: author.id, manager_id: manager.id, executor_id: executor.id }

  context 'when current user regular user' do
    it { expect(subject).not_to be_able_to_approve(user, order_created) }
    it { expect(subject).not_to be_able_to_delete(user, order_created) }
    it { expect(subject).not_to be_able_to_complete(user, order_created) }
  end

  context 'when current user is athor' do
    it { expect(subject).not_to be_able_to_approve(author, order_created) }
    it { expect(subject).to be_able_to_delete(author, order_created) }
    it { expect(subject).not_to be_able_to_complete(author, order_created) }
  end

  context 'when current user is manager' do
    it { expect(subject).not_to be_able_to_delete(manager, order_created) }
    it { expect(subject).to be_able_to_approve(manager, order_created) }
    it { expect(subject).not_to be_able_to_complete(manager, order_created) }
  end

end