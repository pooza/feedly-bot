namespace :feedly do
  desc 'crawl'
  task :crawl do
    sh File.join(FeedlyBot::Environment.dir, 'bin/crawl.rb')
  end
end
