#!/usr/bin/env ruby

path = File.expand_path(__FILE__)
while (File.ftype(path) == 'link')
  path = File.expand_path(File.readlink(path))
end
ROOT_DIR = File.dirname(path)
$LOAD_PATH.push(File.join(ROOT_DIR, 'lib'))

require 'bundler/setup'
require 'feedly_deliverer/config'
require 'feedly_deliverer/mail_deliverer'
require 'feedlr'
require 'syslog/logger'

config = FeedlyDeliverer::Config.new
config['days'] = 7
config.parse!

if (config['access_token']['expires_on'] - config['days']) < Date.today
  deliverer = FeedlyDeliverer::MailDeliverer.new
  deliverer.subject = 'アクセストークンの期限'
  deliverer.to = config['mail_to']
  deliverer.body = [
    'アクセストークンの期限は、',
    config['access_token']['expires_on'].to_s,
    'です。更新しましょう。',
    '<https://feedly.com/v3/auth/dev>',
  ].join
  deliverer.deliver!
end

feedlr = Feedlr::Client.new({
  oauth_access_token: config['access_token']['token'],
  sandbox: false,
  logger: Syslog::Logger.new('feedlr'),
})

entries = []
begin
  category_id = "user/#{feedlr.user_profile.id}/category/global.all"
  entry_ids = feedlr.stream_entries_ids(category_id, count:100, unreadOnly:true)['ids']
  feedlr.user_entries(entry_ids).each do |entry|
    entries.push({
      origin: entry['origin']['title'],
      title: entry['title'],
      published: Time.at((entry['published'].to_i / 1000).ceil),
      url: entry['alternate'].first['href'],
    })
  end
rescue => e
  deliverer = FeedlyDeliverer::MailDeliverer.new
  deliverer.subject = e.class
  deliverer.to = config['mail_to']
  deliverer.body = e.message
  deliverer.deliver!
  exit
end

unless entries.empty?
  body = []
  entries.each do |entry|
    body.push("サイト: #{entry[:origin]}")
    body.push("タイトル: #{entry[:title]}")
    body.push("日付: #{entry[:published].strftime('%F %T')}")
    body.push("URL: <#{entry[:url]}>")
    body.push(nil)
  end

  deliverer = FeedlyDeliverer::MailDeliverer.new
  deliverer.subject = "新着記事 #{Time.now.strftime('%F %T')}"
  deliverer.to = config['mail_to']
  deliverer.body = body.join("\n")
  deliverer.deliver!
end