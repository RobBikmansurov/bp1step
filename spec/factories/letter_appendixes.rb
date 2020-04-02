# frozen_string_literal: true

FactoryBot.define do
  factory :letter_appendix do
    appendix { File.new(Rails.root.join('spec/support/test.odt')) }
    name { 'MyString' }
    letter
  end
end
