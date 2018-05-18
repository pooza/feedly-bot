require 'addressable/uri'
require 'httparty'
require 'json'
require 'feedly-bot/config'
require 'feedly-bot/logger'

module FeedlyBot
  class Slack
    def initialize(url)
      @url = Addressable::URI.parse(url)
      @logger = Logger.new
    end

    def say(message)
      response = HTTParty.post(@url, {
        body: {text: JSON.pretty_generate(message)}.to_json,
        headers: {'Content-Type' => 'application/json'},
        ssl_ca_file: File.join(ROOT_DIR, 'cert/cacert.pem'),
      })
      if message.class.is_a?(Exception)
        @logger.error(message)
      else
        @logger.info(message)
      end
      return response
    end

    def self.all
      return enum_for(__method__) unless block_given?
      if hook = Config.instance['local']['slack']['hook']
        yield Slack.new(hook['url'])
      else
        Config.instance['local']['slack']['hooks'].each do |url|
          yield Slack.new(url)
        end
      end
    end
  end
end
