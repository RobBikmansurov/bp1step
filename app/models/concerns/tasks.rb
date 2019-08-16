# frozen_string_literal: true

module Tasks
  def status_mark
    return '&#x2606;' if status < 10
    return '&#x2714;' if status > 80

    '&#x2605;'
  end
end
