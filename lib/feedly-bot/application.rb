require 'feedly-bot/feedly'
require 'feedly-bot/slack'

module FeedlyBot
  class Application
    def initialize
      @slack = Slack.new
      @feedly = Feedly.new
    end

    def execute
      if @feedly.old?
        @slack.say({
          expires_on: @feedly.expires_on,
          url: @feedly.auth_url,
        })
      end
      @feedly.entries do |entry|
        @slack.say(entry)
      end
    rescue => e
      @slack.say({
        class: e.class,
        message: e.message,
      })
    end
  end
end
