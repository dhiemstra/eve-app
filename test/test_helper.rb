# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
$LOAD_PATH.unshift File.dirname(__FILE__)

require "dummy/config/environment"
require "rails/test_help"

ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
ActiveSupport::TestCase.fixtures :all

class ActiveSupport::TestCase
  self.use_instantiated_fixtures = false

  def load_data_file(filename)
    File.read(File.expand_path("../support/data/#{filename}", __FILE__))
  end
end
