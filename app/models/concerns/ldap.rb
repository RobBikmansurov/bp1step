# frozen_string_literal: true

module LDAP
  def ldap_lastname
    lastname = Devise::LDAP::Adapter.get_ldap_param(username, 'sn')
    lastname&.first&.force_encoding('UTF-8')
  end

  def ldap_firstname
    tempname = Devise::LDAP::Adapter.get_ldap_param(username, 'givenname')
    tempname&.first&.force_encoding('UTF-8')
  end

  def ldap_displayname
    Devise::LDAP::Adapter.get_ldap_param(username, 'displayname')
  end

  def ldap_email
    Devise::LDAP::Adapter.get_ldap_param(username, 'mail')
  end
end
