# frozen_string_literal: true

require 'spec_helper'

describe 'Elasticsearch Installation' do
  describe docker_build('elastichq/Dockerfile', rm: true) do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'ElasticHQ instance' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_cmd %w[python application.py --port 5000 --host 0.0.0.0] }
    it { should have_expose '5000' }
    it { should have_user 'nobody' }
    it { should have_workdir '/elasticHQ' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image) do
      describe file('/elasticHQ') do
        it { should be_directory }
      end

      describe file('/elasticHQ/requirements.txt') do
        it { should be_file }
        it { should contain 'jmespath==0.9.3' }
      end

      %w[git bash].each do |package|
        describe "Describe package #{package}" do
          describe package(package) do
            it { should be_installed }
          end

          it 'has package in the path' do
            expect(command("which #{package}").exit_status).to eq 0
          end
        end
      end

      describe process('python') do
        it { should be_running }
        its(:user) { should eq 'root' }
        its(:args) { should include 'application.py --port 5000 --host 0.0.0.0' }
      end

      describe port(5000) do
        it { should be_listening.with('tcp') }
      end
    end
  end
end
