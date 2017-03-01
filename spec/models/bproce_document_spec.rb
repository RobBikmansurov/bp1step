# frozen_string_literal: true
require 'rails_helper'

describe BproceDocument do
  context 'associations' do
    it { should belong_to(:bproce) }
    it { should belong_to(:document) }
  end
end
