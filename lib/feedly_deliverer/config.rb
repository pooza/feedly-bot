require 'yaml'

module FeedlyDeliverer
  class Config < Hash
    attr :key, true

    def parse!
      files.each do |f|
        if File.exist?(f)
          self.update(YAML.load_file(f))
          break
        end
      end
    end

    private
    def files
      return [
        File.join(ROOT_DIR, 'feedly_deliverer.yaml'),
        '/usr/local/etc/feedly_deliverer.yaml',
        '/etc/feedly_deliverer.yaml',
      ]
    end
  end
end