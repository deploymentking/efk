# frozen_string_literal: true

require 'spec_helper'

describe 'Fluentd Installation' do
  describe docker_build('fluentd/Dockerfile', tag: 'efk_fluentd', rm: true, log_level: 'ci') do
    it { should have_label 'Author' => 'Lee Myring <mail@thinkstack.io>' }
    it { should have_label 'Description' => 'Fluentd instance' }
    it { should have_label 'Version' => '2.0.0' }
    it { should have_maintainer 'Lee Myring' }
    it { should have_expose '5140' }
    it { should have_expose '24224' }
    it { should have_user '1000' }
    it { should have_env 'TINI_VERSION' => '0.18.0' }

    its(:arch) { should eq 'amd64' }
    its(:os) { should eq 'linux' }

    describe docker_run(described_image, tag: 'efk_fluentd') do
      %w[
        /fluentd/log
        /fluentd/etc
        /fluentd/plugins
      ].each do |folder|
        describe file(folder) do
          it { should be_directory }
        end
      end

      describe file('/fluentd/etc/fluent.conf') do
        it { should be_file }
        it { should contain '<label @mainstream>' }
        it { should contain '<match docker.**>' }
      end
    end
  end
end
