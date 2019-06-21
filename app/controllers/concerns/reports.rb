# frozen_string_literal: true

# обшие методы при получении отчетов
module Reports
  extend ActiveSupport::Concern

  def report_footer(report)
    report.add_field 'REPORT_DATE', Time.zone.today.strftime('%d.%m.%Y')
    report.add_field 'USER_POSITION', current_user.position.mb_chars.capitalize.to_s
    report.add_field 'USER_NAME', current_user.displayname
    report.add_field 'REPORT_DATE', Date.current.strftime('%d.%m.%Y')
  end
end
