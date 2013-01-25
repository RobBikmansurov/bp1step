class DocumentMailer < ActionMailer::Base
  default from: "robb@bankperm.ru"

  def file_not_found_email(document, user)
    @doc = document
    @user = user
    mail(:to => user.email, :subject => "bp1step: document file not found!")
  end
end
