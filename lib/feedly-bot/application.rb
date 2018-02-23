require 'feedly-bot/feedly'
require 'feedly-bot/slack'
require 'feedly-bot/package'
require 'feedly-bot/logger'

module FeedlyBot
  class Application
    def initialize
      @slack = Slack.new
      @logger = Logger.new(Package.name)
      @feedly = Feedly.new
    end

    def execute
      @logger.info({message: 'start', version: Package.version})
      if @feedly.outdated?
        message = {expires_on: @feedly.expires_on, url: @feedly.auth_url}
        @slack.say(message)
        @logger.info(message)
      end
      @feedly.entries do |entry|
        @slack.say(entry)
        @logger.info(entry)
      end
      @logger.info({message: 'complete', version: Package.version})
    rescue => e
      message = {class: e.class, message: e.message, version: Package.version}
      @slack.say(message)
      @logger.error(message)
    end
  end
end
