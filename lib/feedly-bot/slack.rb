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
      HTTParty.post(@url, {
        body: {text: JSON.pretty_generate(message)}.to_json,
        headers: {'Content-Type' => 'application/json'},
        ssl_ca_file: File.join(ROOT_DIR, 'cert/cacert.pem'),
      })
      if message.class.is_a?(Exception)
        @logger.error(message)
      else
        @logger.info(message)
      end
    end
  end
end
