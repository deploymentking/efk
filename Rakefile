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

desc 'Start the EFK stack components (including elasticHQ)'
task :efk do
  trap('SIGINT') do
    puts 'Stopping log tail...'
    exit
  end
  sh './scripts/start-efk.sh'
end

desc 'Start the Kubernetes Minikube components'
task :k8s do
  trap('SIGINT') do
    puts 'Stopping log tail...'
    exit
  end
  sh './scripts/start-k8s.sh'
end

desc 'Restart the Fluentd container'
task :fluentd_restart do
  trap('SIGINT') do
    puts 'Stopping log tail...'
    exit
  end
  sh './scripts/reset-fluentd.sh'
end

desc 'Start 1..n source containers'
task :up do
  ARGV.drop(1).each do |source|
    sh "./scripts/start-source.sh #{source}"
  end
end

task default: %w[style test]
