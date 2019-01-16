# frozen_string_literal: true

require 'rails_helper'

describe BusinessRole do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:bproce_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:bproce) }
    it { is_expected.to have_many(:user_business_role).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_business_role) } # приложение относится ко многим процессам
  end
end
