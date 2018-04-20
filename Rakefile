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

desc 'Run all style checks'
task style: %w[rubocop]

desc 'Run Rubocop style checks'
task :rubocop do
  sh 'bundle exec rubocop'
end

desc 'Run all the tests'
task :test do
  sh 'bundle install'
  sh 'bundle exec rspec'
end

desc 'Start the EFK stack components (including elasticHQ)'
task :efk do
  trap('SIGINT') do
    puts 'Cancelled EFK stack launch...'
    exit
  end
  sh './scripts/start-efk.sh'
end

desc 'Start the Kubernetes Minikube components'
task :k8s do
  trap('SIGINT') do
    puts 'Cancelled Kubernetes cluster launch...'
    exit
  end
  sh './scripts/start-k8s.sh'
end

desc 'Restart the Fluentd container'
task :reset_fluentd do
  trap('SIGINT') do
    puts 'Cancelled fluentd reset...'
    exit
  end
  sh './scripts/reset-fluentd.sh'
end

desc 'Start 1..n source containers'
task :start, :source do |_task, args|
  sh "./scripts/start-source.sh #{args[:source]}"
end

desc 'Start all source containers'
task :all_sources do
  %w[via-fluentd-gem via-logging-driver via-td-agent via-td-agent-bit].each do |source|
    Rake::Task['start'].invoke(source)
    Rake::Task['start'].reenable
  end
end

desc 'Stop the entire EFK stack, any additional sources and the minikube cluster'
task :down do
  sh './scripts/stop-efk.sh || true'
end

desc 'Bring up the EFK stack with Kubernetes and all the sources'
task up: %w[down clean efk k8s all_sources]

desc 'Run ALL the rake tasks: clean test and build'
task everything: %w[clean style test efk k8s all_sources]
