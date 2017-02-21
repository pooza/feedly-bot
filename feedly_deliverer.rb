#!/usr/bin/env ruby

path = File.expand_path(__FILE__)
while (File.ftype(path) == 'link')
  path = File.expand_path(File.readlink(path))
end
ROOT_DIR = File.dirname(path)
$LOAD_PATH.push(File.join(ROOT_DIR, 'lib'))

require 'feedly_deliverer/config'
require 'feedly_deliverer/mail_deliverer'

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
