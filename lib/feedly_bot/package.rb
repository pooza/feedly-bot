module FeedlyBot
  module Package
    def environment_class
      return 'FeedlyBot::Environment'
    end

    def package_class
      return 'FeedlyBot::Package'
    end

    def config_class
      return 'FeedlyBot::Config'
    end

    def logger_class
      return 'FeedlyBot::Logger'
    end

    def self.name
      return 'feedly-bot'
    end

    def self.version
      return Config.instance['/package/version']
    end

    def self.url
      return Config.instance['/package/url']
    end

    def self.full_name
      return "#{name} #{version}"
    end

    def self.user_agent
      return "#{name}/#{version} (#{url})"
    end
  end
end
