require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'

module FeedlyBot
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Config
  autoload :Error
  autoload :Environment
  autoload :Feedly
  autoload :Logger
  autoload :Package
  autoload :Slack

  autoload_under 'error' do
    autoload :ConfigError
  end
end
