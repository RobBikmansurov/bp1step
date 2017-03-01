# frozen_string_literal: true
require 'spec_helper'

describe DocumentMailer do
  it 'should have access to URL helpers' do
    -> { gadgets_url }.should_not raise_error
  end
end
