require File.expand_path('../boot', __FILE__)

require 'rails/all'

#Need this require to support old syntax
#https://github.com/mislav/will_paginate/wiki/Backwards-incompatibility
require 'will_paginate/array'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Socialatitude
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = 'Eastern Time (US & Canada)'

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w(jquery jquery-ui rails event_calendar plugins script)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec, :fixture => false, :views => false
    end

  end
end
