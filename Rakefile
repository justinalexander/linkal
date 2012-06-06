# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Socialatitude::Application.load_tasks

Rake::Task["db:test:prepare"].enhance do
  # make autotest run after redoing test database
  touch File.join(Rails.root, 'spec', 'spec_helper.rb')
end

