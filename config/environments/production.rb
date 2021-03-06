# Settings specified here will take precedence over those in config/environment.rb

# #DEVELOPMENT
# # In the development environment your application's code is reloaded on
# # every request.  This slows down response time but is perfect for development
# # since you don't have to restart the webserver when you make code changes.
# config.cache_classes = false
# 
# # Log error messages when you accidentally call methods on nil.
# config.whiny_nils = true
# 
# # Show full error reports and disable caching
# config.action_controller.consider_all_requests_local = true
# config.action_controller.perform_caching             = false
# # config.action_view.cache_template_extensions         = false
# config.action_view.debug_rjs                         = true
# 
# # needed for Avatar::Source::RailsAssetSource
# config.action_controller.asset_host                  = "http://localhost:3000"
# 


# #PRODUCTION
# # In the development environment your application's code is reloaded on
# # every request.  This slows down response time but is perfect for development
# # since you don't have to restart the webserver when you make code changes.
# config.cache_classes = true
# 
# # Log error messages when you accidentally call methods on nil.
# config.whiny_nils = false
# 
# # Show full error reports and disable caching
# config.action_controller.consider_all_requests_local = true
# config.action_controller.perform_caching             = true
# # config.action_view.cache_template_extensions         = true
# config.action_view.debug_rjs                         = false
# 
# # needed for Avatar::Source::RailsAssetSource
# config.action_controller.asset_host                  = "http://73s.org"



#PRODUCTION
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = false

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
# config.action_view.cache_template_extensions         = true
config.action_view.debug_rjs                         = false

# needed for Avatar::Source::RailsAssetSource
config.action_controller.asset_host                  = "http://73s.org"




# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
 :address  => "localhost",
 :port  => '25', 
 :domain  => '73s.org',
 :user_name  => "admin.73s-org",
 :password  => "mwhmwh",
 :authentication  => :login
}

#config.action_mailer.delivery_method = :test

config.after_initialize do
  #require 'application' unless Object.const_defined?(:ApplicationController)
  ForumsController.class_eval do
    #include less_authentication
    helper ApplicationHelper

    layout "application"

    before_filter :logged_in?
  end
  TopicsController.class_eval do
    #include AuthenticatedSystem
    helper ApplicationHelper

    layout "application"

    before_filter :logged_in?
  end
  PostsController.class_eval do
    #include AuthenticatedSystem
    helper ApplicationHelper

    layout "application"

    before_filter :logged_in?
  end
end

