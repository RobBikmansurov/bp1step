# frozen_string_literal: true
# Get the deployed git revision to display in the footer
module Git
  REVISION = File.exist?(File.join(Rails.root, 'REVISION')) ? File.open(File.join(Rails.root, 'REVISION'), 'r') { |f| GIT_REVISION = f.gets.chomp } : nil
  VERSION = File.exist?(File.join(Rails.root, 'VERSION')) ? File.open(File.join(Rails.root, 'VERSION'), 'r') { |f| GIT_VERSION = f.gets.chomp } : nil
end
