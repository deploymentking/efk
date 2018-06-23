# frozen_string_literal: true

require 'spec_helper'

describe 'Fluentd Installation' do
  describe docker_build('fluentd/Dockerfile', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Fluentd instance' }
    it { should have_label 'Version' => '1.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_entrypoint '/bin/entrypoint.sh' }
    it { should have_expose '5140' }
    it { should have_expose '24224' }
    it { should have_user 'nobody' }
    it { should have_env 'DUMB_INIT_VERSION' => '1.2.0' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image) do
      it 'is a Linux distro' do
        expect(command('uname').stdout).to include 'Linux'
      end

      %w[
        /fluentd/log
        /fluentd/etc
        /fluentd/plugins
      ].each do |folder|
        describe file(folder) do
          it { should be_directory }
        end
      end

      # describe file('/fluentd/etc/fluentd.conf') do
      #   it { should be_file }
      #   it { should contain 'cluster.name: elasticsearch' }
      #   it { should contain 'network.host: 0.0.0.0' }
      # end

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
    end
  end
end
