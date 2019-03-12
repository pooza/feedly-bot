module FeedlyBot
  class Crawler
    def initialize
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def crawl
      @logger.info({message: 'start'})
      @feedly.entries do |entry|
        Slack.broadcast(entry)
      end
      @logger.info({message: 'end'})
    rescue => e
      e = Ginseng::Error.create(e)
      Slack.broadcast(e.to_h)
      @logger.error(e.to_h)
      exit 1
    end
  end
end
