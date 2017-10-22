require "bundler/setup"
# load Rails first
require "rails"

# needs to load the app next
require_relative "fake_app/application"

require "stateful_field_for"
require "rspec/rails"
require "pry"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

CreateTables.migrate(:up) unless ActiveRecord::Base.connection.table_exists?("pictures")
