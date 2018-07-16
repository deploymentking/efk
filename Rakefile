# frozen_string_literal: true

desc 'Start all source containers'
task :all_sources do
  %w[via-fluentd-gem via-logging-driver via-td-agent via-td-agent-bit].each do |source|
    Rake::Task['start'].invoke(source)
    Rake::Task['start'].reenable
  end
  sh 'docker ps -a --format "table {{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}"'
end

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

desc 'Stop the entire EFK stack, any additional sources and the minikube cluster'
task :down do
  sh './scripts/stop-efk.sh || true'
end

desc 'Start the EFK stack components (including elasticHQ)'
task :efk do
  trap('SIGINT') do
    puts 'Cancelled EFK stack launch...'
    exit
  end
  sh './scripts/start-efk.sh'
end

desc 'Run ALL the rake tasks: clean test and build'
task everything: %w[down clean style test efk k8s all_sources]

desc 'Start the Kubernetes Minikube components'
task :k8s do
  trap('SIGINT') do
    puts 'Cancelled Kubernetes cluster launch...'
    exit
  end
  sh './scripts/start-k8s.sh'
end

desc 'Start the Prometheus stack component'
task :prometheus do
  trap('SIGINT') do
    puts 'Cancelled Prometheus stack launch...'
    exit
  end
  sh './scripts/start-prometheus.sh'
end

desc 'Stop the entire EFK stack, additional sources, minikube and then delete all efk_* images'
task :purge do
  Rake::Task['down'].invoke
  sh 'docker image ls --quiet --filter \'reference=efk_*:*\' | xargs docker rmi -f'
  sh 'docker volume prune -f'
end

desc 'Restart a Docker container; port is optional, if supplied will wait for port to be available before tailing logs'
task :restart, [:name, :port] do |_task, args|
  trap('SIGINT') do
    exit
  end
  sh "./scripts/restart-container.sh #{args[:name]} #{args[:port]}"
end

desc 'Run Rubocop style checks'
task :rubocop do
  sh 'bundle exec rubocop'
end

desc 'Start 1..n source containers'
task :start, :source do |_task, args|
  sh "./scripts/start-source.sh #{args[:source]}"
end

desc 'Run all style checks'
task style: %w[rubocop]

desc 'Run all the tests'
task :test do
  sh 'bundle install'
  sh 'bundle exec rspec'
end

desc 'Bring up the EFK stack with Kubernetes and all the sources'
task up: %w[down clean efk k8s all_sources]
