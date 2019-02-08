dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')
ENV['SSL_CERT_FILE'] ||= File.join(dir, 'cert/cacert.pem')

require 'bundler/setup'
require 'feedly_bot'

environment = FeedlyBot::Environment

namespace :cert do
  desc 'update cert'
  task :update do
    require 'httparty'
    File.write(
      File.join(environment.dir, 'cert/cacert.pem'),
      HTTParty.get('https://curl.haxx.se/ca/cacert.pem'),
    )
  end

  desc 'check cert'
  task :check do
    if `git status`.include?('cacert.pem')
      STDERR.puts 'cert is not fresh.'
      exit 1
    end
  end
end

namespace :bundle do
  desc 'update gems'
  task :update do
    sh 'bundle update'
  end

  desc 'check gems'
  task :check do
    if `git status`.include?('Gemfile.lock')
      STDERR.puts 'gems is not fresh.'
      exit 1
    end
  end
end

namespace :repos do
  desc 'update cert/gems'
  task update: ['cert:update', 'bundle:update']

  desc 'check cert/gems'
  task check: ['cert:check', 'bundle:check']
end
