VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_hosts 'chromedriver.storage.googleapis.com'
end
