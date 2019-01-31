# frozen_string_literal: true

class AgentContract < ApplicationRecord
  belongs_to :agent
  belongs_to :contract
end
