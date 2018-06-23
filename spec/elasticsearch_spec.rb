# frozen_string_literal: true

require 'spec_helper'

describe 'Elasticsearch Installation' do
  describe docker_build('elasticsearch/Dockerfile', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Elasticsearch instance' }
    it { should have_label 'Version' => '1.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_entrypoint '/usr/local/bin/docker-entrypoint.sh' }
    it { should have_expose '9200' }
    it { should have_user 'nobody' }
    it { should have_workdir '/usr/share/elasticsearch' }
    it { should have_env 'ELASTIC_CONTAINER' => 'true' }
    it { should have_env 'JAVA_HOME' => '/usr/lib/jvm/jre-1.8.0-openjdk' }
    it { should have_env 'PATH' => '/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image) do
      it 'is a Linux distro' do
        expect(command('uname').stdout).to include 'Linux'
      end

      describe file('/usr/share/elasticsearch') do
        it { should be_directory }
      end

      describe file('/usr/share/elasticsearch/config/elasticsearch.yml') do
        it { should be_file }
        it { should contain 'cluster.name: elasticsearch' }
        it { should contain 'network.host: 0.0.0.0' }
      end

      describe file('/usr/share/elasticsearch/config/readonlyrest.yml') do
        it { should be_file }
        %w[FLUENTD KIBANA-ADMIN KIBANA-RO KIBANA-RW ELASTICHQ TERMINAL].each do |name|
          it { should contain "  - name: \"::#{name}::\"" }
        end
        %w[agent apache bit fluent gem k8s redis].each do |index|
          it { should contain "      - \"#{index}-*\"" }
        end
        %w[
          9545566c208f39b107b456430dd3b4b5b08eaa6c2abc62b2d6bcbb79c95b619c
          ab8aa94dd63debfa31ef8a9eae9582dcb252c06cdb6313e123546cc8edfeaf3e
          1f2c06fd49c4c8912253bcb0671f3279142c7a1d9f59bdf76a10534740332deb
          00045d3d78f2fc23914016fb8234b94f3d99e488f75c41740ac562a22fe97bc1
          ccdff8600d84f900fe3419c286524788f8102581a40e591cd765ac724634bf15
          fc8d9571165e073ac292f6b42b2ff9d36b80a19e6396e1de30b0a83881cd4b2a
        ].each do |shasum|
          it { should contain "    auth_key_sha256: #{shasum}" }
        end
      end

      %w[bash].each do |package|
        describe "Describe package #{package}" do
          describe package(package) do
            it { should be_installed }
          end

          it 'has package in the path' do
            expect(command("which #{package}").exit_status).to eq 0
          end
        end
      end

      describe process('java') do
        it { should be_running }
        its(:user) { should eq 'elasticsearch' }
        its(:args) { should include '-Xms1g -Xmx1g' }
      end
    end
  end
end
