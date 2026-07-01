require 'chefspec'
require 'chefspec/policyfile'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
end
