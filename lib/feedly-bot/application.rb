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
        Slack.all.map{ |h| h.say(entry)}
      end
      @logger.info({message: 'end'})
    rescue => e
      Slack.all.map{ |h| h.say({class: e.class, message: e.message})}
      exit 1
    end
  end
end
