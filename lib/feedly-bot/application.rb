require 'feedly-bot/feedly'
require 'feedly-bot/slack'
require 'feedly-bot/logger'
require 'feedly-bot/config'

module FeedlyBot
  class Application
    def initialize
      @config = Config.instance
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def execute
      @logger.info({message: 'start'})
      @feedly.entries do |entry|
        hooks.map{ |h| h.say(entry)}
      end
      @logger.info({message: 'end'})
    rescue => e
      hooks.map{ |h| h.say({class: e.class, message: e.message})}
      exit 1
    end

    private

    def hooks
      return enum_for(__method__) unless block_given?
      if @config['local']['slack']['hook'] # 2.0以前
        yield Slack.new(@config['local']['slack']['hook']['url'])
      else
        @config['local']['slack']['hooks'].each do |url|
          yield Slack.new(url)
        end
      end
    end
  end
end
