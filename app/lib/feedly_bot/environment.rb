module FeedlyBot
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return FeedlyBot.dir
    end
  end
end
