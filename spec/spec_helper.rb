# frozen_string_literal: true

require "lotr"
require "vcr"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<THE_ONE_API_KEY>") { test_lotr_api_key }
end

def test_lotr_api_key
  ENV.fetch "THE_ONE_API_KEY", "test_api_key"
end
