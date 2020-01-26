dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'feedly_bot'

[:crawl].each do |action|
  desc "alias of feedly:#{action}"
  task action => "feedly:#{action}"
end

Dir.glob(File.join(FeedlyBot::Environment.dir, 'app/task/*.rb')).sort.each do |f|
  require f
end
