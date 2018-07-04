require 'feedly-bot/feedly'
require 'feedly-bot/slack'
require 'feedly-bot/logger'

module FeedlyBot
  class Application
    def initialize
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def execute
      @logger.info({message: 'start'})
      @feedly.entries do |entry|
        Slack.broadcast(entry)
      end
      @logger.info({message: 'end'})
    rescue => e
      message = {class: e.class, message: e.message, backtrace: e.backtrace[0.5]}
      Slack.broadcast(message)
      @logger.error(message)
      exit 1
    end
  end
end
