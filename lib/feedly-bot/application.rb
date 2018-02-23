require 'json'
require 'feedly-bot/feedly'
require 'feedly-bot/slack'

module FeedlyBot
  class Application
    def initialize
      @slack = Slack.new
      @feedly = Feedly.new
      @logger = Application.logger
    end

    def execute
      @logger.info({message: 'start', version: Application.version}.to_json)
      if @feedly.outdated?
        message = {
          expires_on: @feedly.expires_on,
          url: @feedly.auth_url,
        }
        @slack.say(message)
        @logger.info(message.to_json)
      end
      @feedly.entries do |entry|
        @slack.say(entry)
        @logger.info(entry.to_json)
      end
      @logger.info({message: 'complete', version: Application.version}.to_json)
    rescue => e
      message = {
        class: e.class,
        message: e.message,
      }
      @slack.say(message)
      @logger.error(message.to_json)
    end

    def self.name
      return Config.instance['application']['name']
    end

    def self.version
      return Config.instance['application']['version']
    end

    def self.url
      return Config.instance['application']['url']
    end

    def self.full_name
      return "#{Application.name} #{Application.version}"
    end

    def self.logger
      return Syslog::Logger.new(Application.name)
    end
  end
end
