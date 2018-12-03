module FeedlyBot
  class Application
    def initialize
      @logger = Logger.new
      @feedly = Feedly.new
    end

    def execute
      @logger.info({message: 'start'})
      @feedly.entries do |entry|
        Slack.broadcast(entry)
      end
      @logger.info({message: 'end'})
    rescue => e
      e = Error.create(e)
      Slack.broadcast(e.to_h)
      @logger.error(e.to_h)
      exit 1
    end
  end
end
