VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end
