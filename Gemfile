# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :unit_tests do
  gem 'json',                              require: false
  gem 'json_pure',                         require: false
  gem 'metadata-json-lint',                require: false
  gem 'puppet-lint', '~> 2.0',             require: false
  gem 'puppet-lint-empty_string-check',    require: false
  gem 'puppet-lint-leading_zero-check',    require: false
  gem 'puppet-lint-unquoted_string-check', require: false
  gem 'puppetlabs_spec_helper', '~> 1.2',  require: false
  gem 'rake', '10.5.0',                    require: false
  gem 'rspec', '~> 2.0',                   require: false
  gem 'rspec-puppet', '>= 2.1.0',          require: false
  gem 'semantic_puppet',                   require: false
end

gem 'facter', ENV['FACTER_GEM_VERSION'], require: false
gem 'puppet', ENV['PUPPET_GEM_VERSION'], require: false

# vim:ft=ruby
