require File.expand_path('../boot', __FILE__)

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Recruit
  class Application < Rails::Application
    require Rails.root.join 'app/models/settings'

    config.autoload_paths += %W(#{config.root}/api #{config.root}/lib #{config.root}/services #{config.root}/observers)

    config.time_zone = 'Beijing'

    config.i18n.default_locale = :"zh-CN"
    config.i18n.enforce_available_locales = false

    config.generators do |g|
      g.assets false
      g.helper false
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl
    end

    config.exceptions_app = self.routes

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
