RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require "RedCloth"

Rails::Initializer.run do |config|
    
  # Cookie sessions (limit = 4K)
  config.action_controller.session = {
    :session_key => '_73s_session',
    :secret      => '81a1d4bbc82cc0daa30bdd4ac94469bb85d8a474b2d4e42b8463fe1adbaa7187715a14c91e67084e0d3203b04dc4d1a682c0a62ac2507b8f84137c32abeda9f5'
  }
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  config.active_record.observers = :user_observer, :contact_observer

  # Make Active Record use UTC-base instead of local time
  config.time_zone = 'UTC'

  # Gem dependencies
  config.gem 'will_paginate', :version => '~> 2.2.2'
  config.gem 'colored', :version=> '1.1'
  # config.gem 'youtube-g', :version=> '0.4.9.9', :lib=>'youtube_g'
  # config.gem 'uuidtools', :version=> '1.0.4'
  # config.gem 'hpricot', :version=> '0.6.164'
  config.gem 'youtube-g', :version=> '0.4.1', :lib=>'youtube_g'
  config.gem 'uuidtools', :version=> '1.0.3'
  config.gem 'hpricot', :version=> '0.6.161'
  # config.gem 'mocha', :version=> '0.9.3'
  config.gem 'redgreen', :version=> '1.2.2' unless ENV['TM_MODE']
  # config.gem 'gcnovus-avatar', :version=> '0.0.7', :lib => 'avatar'
  config.gem 'flickr'
  config.gem 'twitter_oauth'
  config.gem 'gravtastic', :version => '= 2.2.0'
  
end

Less::JsRoutes.generate!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "127.0.0.1",
  :port  => '25', 
  :domain  => '73s.org',
  :user_name  => "admin.73s-org",
  :password  => "mwhmwh",
  :authentication  => :login
}

