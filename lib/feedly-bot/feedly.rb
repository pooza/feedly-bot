require 'feedlr'
require 'feedly-bot/config'
require 'syslog/logger'

module FeedlyBot
  class Feedly
    def initialize
      @config = Config.instance
      @feedlr = Feedlr::Client.new({
        oauth_access_token: @config['local']['access_token']['token'],
        sandbox: false,
        logger: Syslog::Logger.new('feedlr'),
      })
    end

    def entries
      return enum_for(__method__) unless block_given?
      Slack.broadcast({expires_on: expires_on}) if outdated?
      @feedlr.user_entries(entry_ids).each do |entry|
        values = {
          origin: entry['origin']['title'],
          title: entry['title'],
          published: Time.at((entry['published'].to_i / 1000).ceil),
          url: entry['alternate'].first['href'],
        }
        yield values
      end
    end

    def outdated?
      return (expires_on - @config['application']['days']) < Date.today
    end

    def expires_on
      return @config['local']['access_token']['expires_on']
    end

    def auth_url
      return @config['application']['feedly']['auth_url']
    end

    private

    def category_id
      return "user/#{@feedlr.user_profile.id}/category/global.all"
    end

    def entry_ids
      return @feedlr.stream_entries_ids(category_id, count: 100, unreadOnly: true)['ids']
    end
  end
end
