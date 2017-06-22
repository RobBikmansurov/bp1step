# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, 'log/bp1step.log'

every '*/5 8-19 * * 1-6' do
  rake 'bp1step:sync_active_directory_users' # USERS
end

every :day, :at => '07:59am' do
  rake 'bp1step:check_letters_duedate' # LETTERS
end
