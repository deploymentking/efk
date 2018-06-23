# frozen_string_literal: true

require 'spec_helper'

describe 'Kibana Installation' do
  describe docker_build('kibana/Dockerfile', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Kibana instance' }
    it { should have_label 'Version' => '1.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_cmd %w[/bin/bash /usr/local/bin/kibana-docker] }
    it { should have_expose '5601' }
    it { should have_user 'kibana' }
    it { should have_workdir '/usr/share/kibana' }
    it { should have_env 'ELASTIC_CONTAINER' => 'true' }
    # it { should have_env 'PATH' => '/usr/share/kibana/bin:$PATH' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image) do
      it 'is a Linux distro' do
        expect(command('uname').stdout).to include 'Linux'
      end

      describe file('/usr/share/kibana') do
        it { should be_directory }
      end

      # describe file('/fluentd/etc/kibana.yml') do
      #   it { should be_file }
      #   it { should contain 'elasticsearch.url: http://elasticsearch:9200' }
      #   it { should contain 'elasticsearch.username: kibana' }
      #   it { should contain 'elasticsearch.password: kibana' }
      # end

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
