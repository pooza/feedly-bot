require 'feedly-bot/feedly'
require 'feedly-bot/slack'
require 'feedly-bot/logger'

module FeedlyBot
  class Application
    def initialize
      @slack = Slack.new
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def execute
      @logger.info({message: 'start'})
      if @feedly.outdated?
        message = {expires_on: @feedly.expires_on, url: @feedly.auth_url}
        @slack.say(message)
        @logger.info(message)
      end
      @feedly.entries do |entry|
        @slack.say(entry)
        @logger.info(entry)
      end
      @logger.info({message: 'complete'})
    rescue => e
      message = {class: e.class, message: e.message}
      @slack.say(message)
      @logger.error(message)
    end
  end
end
