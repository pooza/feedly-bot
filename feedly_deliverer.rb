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
config.parse!

p config