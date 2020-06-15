# frozen_string_literal: true

require 'spec_helper'

describe 'Elasticsearch Installation' do
  describe docker_build('elasticsearch/Dockerfile', tag: 'efk_elasticsearch', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Elasticsearch instance' }
    it { should have_label 'Version' => '2.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_expose '9200' }
    it { should have_user 'nobody' }
    it { should have_workdir '/usr/share/elasticsearch' }
    it { should have_env 'ELASTIC_CONTAINER' => 'true' }
    it { should have_env 'PATH' => '/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image, tag: 'efk_elasticsearch', env: {"discovery.type" => "single-node"}) do
      it 'is a Linux distro' do
        expect(command('uname').stdout).to include 'Linux'
      end

      describe file('/usr/share/elasticsearch') do
        it { should be_directory }
      end

      describe file('/usr/share/elasticsearch/config/elasticsearch.yml') do
        it { should be_file }
        it { should contain 'cluster.name: "docker-cluster"' }
        it { should contain 'network.host: 0.0.0.0' }
      end

      describe process('java') do
        it { should be_running }
        its(:user) { should eq 'elasticsearch' }
        its(:args) { should include '-Xms1g -Xmx1g' }
      end
    end
  end
end
