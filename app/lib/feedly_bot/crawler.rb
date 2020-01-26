module FeedlyBot
  class Crawler
    def initialize
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def crawl
      @feedly.entries do |entry|
        Slack.broadcast(entry)
      rescue => e
        @logger.error(e)
        next
      end
    end
  end
end
