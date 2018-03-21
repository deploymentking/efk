# frozen_string_literal: true

desc 'Clean some generated files'
task :clean do
  %w[
    .bundle
    .cache
    coverage
    doc
    *.gem
    Gemfile.lock
    .inch
    vendor
  ].each { |f| FileUtils.rm_rf(Dir.glob(f)) }
end

desc 'Run Rubocop style checks'
task :rubocop do
  sh 'bundle exec rubocop'
end

desc 'Run all style checks'
task style: %w[rubocop]

desc 'Run all the tests'
task :test do
  sh 'bundle install'
  sh 'bundle exec rspec'
end

task default: %w[style test]
