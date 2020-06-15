# frozen_string_literal: true

require 'spec_helper'

describe 'Kibana Installation' do
  describe docker_build('kibana/Dockerfile', tag: 'efk_kibana', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Kibana instance' }
    it { should have_label 'Version' => '2.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_expose '5601' }
    it { should have_user 'kibana' }
    it { should have_workdir '/usr/share/kibana' }
    it { should have_env 'ELASTIC_CONTAINER' => 'true' }
    it { should have_env 'PATH' => '/usr/share/kibana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image, tag: 'efk_kibana') do
      it 'is a Linux distro' do
        expect(command('uname').stdout).to include 'Linux'
      end

      describe file('/usr/share/kibana') do
        it { should be_directory }
      end

      describe file('/usr/share/kibana/config/kibana.yml') do
        it { should be_file }
        it { should contain 'server.name: kibana' }
        it { should contain 'server.host: "0"' }
        it { should contain 'elasticsearch.hosts: [ "http://elasticsearch:9200" ]' }
        it { should contain 'monitoring.ui.container.elasticsearch.enabled: true' }
      end

      %w[fontconfig fontconfig].each do |package|
        describe "Describe package #{package}" do
          describe package(package) do
            it { should be_installed }
          end
        end
      end
    end
  end
end
