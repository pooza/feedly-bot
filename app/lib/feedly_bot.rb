require 'active_support'
require 'active_support/core_ext'
require 'zeitwerk'
require 'ginseng'
require 'yaml'

module FeedlyBot
  def self.dir
    return File.expand_path('../..', __dir__)
  end

  def self.loader
    config = YAML.load_file(File.join(dir, 'config/autoload.yaml'))
    loader = Zeitwerk::Loader.new
    loader.inflector.inflect(config['inflections'])
    loader.push_dir(File.join(dir, 'app/lib'))
    config['dirs'].each do |d|
      loader.push_dir(File.join(dir, 'app', d))
    end
    loader.setup
  end
end

FeedlyBot.loader
