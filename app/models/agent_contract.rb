class AgentContract < ActiveRecord::Base
  belongs_to :agent
  belongs_to :contract
end
