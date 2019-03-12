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
        @logger.error(Ginseng::Error.create(e).to_h)
      end
    rescue => e
      e = Ginseng::Error.create(e)
      Slack.broadcast(e.to_h)
      @logger.error(e.to_h)
      exit 1
    end
  end
end
