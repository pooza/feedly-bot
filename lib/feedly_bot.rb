require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'

module FeedlyBot
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Config
  autoload :Feedly
  autoload :Logger
  autoload :Package
  autoload :Slack
end
