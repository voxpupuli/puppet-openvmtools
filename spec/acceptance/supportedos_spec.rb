# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'openvmtools class' do
  context 'default parameters' do
    it 'work with no errors' do
      pp = <<-EOS
        class { 'openvmtools': }
      EOS

      # not run idempotently becase service not start cause
      # systemd condition ConditionVirtualization=vmware
      # if the host is not virtualized under vmware it fail
      apply_manifest(pp, catch_failures: true)
    end

    describe package('open-vm-tools') do
      it { is_expected.to be_installed }
    end

    describe service('vmtoolsd') do
      it { is_expected.to be_enabled }
    end
  end
end
