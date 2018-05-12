require 'addressable/uri'
require 'httparty'
require 'json'
require 'feedly-bot/config'

module FeedlyBot
  class Slack
    def initialize
      @config = Config.instance['local']['slack']
      @url = @config['hook']['url']
    end

    def say(message)
      HTTParty.post(@url, {
        body: {text: JSON.pretty_generate(message)}.to_json,
        headers: {'Content-Type' => 'application/json'},
        ssl_ca_file: File.join(ROOT_DIR, 'cert/cacert.pem'),
      })
    end
  end
end
