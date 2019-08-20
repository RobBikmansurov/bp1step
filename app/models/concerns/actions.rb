# frozen_string_literal: true

module Actions
  def action
    ''
  end

  def action=(action)
    self.result += action if action.present?
  end
end
