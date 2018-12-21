ROOT_DIR = File.expand_path(__dir__)
$LOAD_PATH.push(File.join(ROOT_DIR, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(ROOT_DIR, 'Gemfile')
ENV['SSL_CERT_FILE'] ||= File.join(ROOT_DIR, 'cert/cacert.pem')

require 'bundler/setup'

namespace :cert do
  desc 'update cert'
  task :update do
    require 'httparty'
    File.write(
      File.join(ROOT_DIR, 'cert/cacert.pem'),
      HTTParty.get('https://curl.haxx.se/ca/cacert.pem'),
    )
  end
end
