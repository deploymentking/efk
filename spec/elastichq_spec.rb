# frozen_string_literal: true

require 'spec_helper'

describe 'ElasticHQ Installation' do
  describe docker_build('elastichq/Dockerfile', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'ElasticHQ instance' }
    it { should have_label 'Version' => '1.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_user 'nobody' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image) do
      describe file('/src') do
        it { should be_directory }
      end

      describe file('/src/requirements.txt') do
        it { should be_file }
        it { should contain 'jmespath==0.9.3' }
      end

      %w[bash gcc].each do |package|
        describe "Describe package #{package}" do
          describe package(package) do
            it { should be_installed }
          end

          it 'has package in the path' do
            expect(command("which #{package}").exit_status).to eq 0
          end
        end
      end

      describe command('pidof supervisord') do
        its(:stdout) { should match /1/ }
      end

      describe port(5000) do
        it { should be_listening.with('tcp') }
      end
    end
  end
end
