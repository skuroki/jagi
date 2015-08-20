require 'carrierwave/test/matchers'
include CarrierWave::Test::Matchers

CarrierWave.configure do |config|
  config.enable_processing = false
end

