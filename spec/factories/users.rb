# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:author] do
    sequence(:id, &:to_s)
    username      { "u#{id}" }
    email         { "mail#{id}@example.com" }
    displayname   { "displayname#{id}" }
    lastname      { "lastname#{id}" }
    firstname     { "firstname#{id}" }
    password        { 'password' }
    # password_confirmation 'password'
    encrypted_password { 'secret' }
    last_sign_in_at { 1.month.ago }
    active { true }
    position { 'position' }
    # User.new :avatar => Rails.root.join("spec/factories/images/rails.png").open
    # avatar { fixture_file_upload(Rails.root.join('spec/factories/images/rails.png'), 'image/png') }
    # avatar { Rails.root.join("spec/factories/images/rails.png").open }

    disable_ldap { true }
  end
end
