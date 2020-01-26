require 'feedlr'
require 'syslog/logger'

module FeedlyBot
  class Feedly
    def initialize
      @config = Config.instance
      @feedlr = Feedlr::Client.new(
        oauth_access_token: @config['/access_token/token'],
        sandbox: false,
        logger: Syslog::Logger.new('feedlr'),
      )
    end

    def entries
      return enum_for(__method__) unless block_given?
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

    def expires_on
      return @config['/access_token/expires_on']
    end

    def auth_url
      return @config['/feedly/auth_url']
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
