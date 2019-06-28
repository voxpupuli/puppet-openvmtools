# frozen_string_literal: true

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'metadata-json-lint/rake_task'

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = [
    'pkg/**/*.pp',
    'spec/**/*.pp',
    'vendor/**/*.pp'
  ]
end

PuppetSyntax.exclude_paths = [
  'pkg/**/*',
  'spec/**/*',
  'vendor/**/*'
]
PuppetSyntax.hieradata_paths = [
  '**/data/**/*.yaml',
  'hiera*.yaml',
  'hieradata/**/*.yaml'
]
