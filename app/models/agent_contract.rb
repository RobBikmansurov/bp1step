# frozen_string_literal: true
class AgentContract < ActiveRecord::Base
  belongs_to :agent
  belongs_to :contract
end
