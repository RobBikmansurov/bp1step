# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :user_order, dependent: :destroy # исполнители
  has_many :user, through: :user_order
  has_one_attached :attachment, dependent: :destroy # файл Распоряжения *.pdf

  attr_reader :action
end
