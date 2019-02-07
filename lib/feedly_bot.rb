require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'

module FeedlyBot
  extend ActiveSupport::Autoload

  autoload :Application
  autoload :Config
  autoload :Environment
  autoload :Feedly
  autoload :Logger
  autoload :Package
  autoload :Slack
end
