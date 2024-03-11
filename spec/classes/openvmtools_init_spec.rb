# frozen_string_literal: true

require 'spec_helper'

describe 'openvmtools' do
  on_supported_os.each do |os, os_facts|
    context "os #{os}" do
      let(:facts) do
        os_facts.merge({ virtual: 'vmware' })
      end
      let(:service_name) do
        case facts[:os]['family']
        when 'Debian'
          'open-vm-tools'
        when 'FreeBSD'
          'vmware_guestd'
        else
          'vmtoolsd'
        end
      end
      let(:package_name) do
        case facts[:os]['family']
        when 'FreeBSD'
          'open-vm-tools-nox11'
        else
          'open-vm-tools'
        end
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_package(package_name) }
      it { is_expected.not_to contain_package('open-vm-tools-desktop') }

      it {
        case facts[:os]['family']
        when 'RedHat'
          is_expected.to contain_service('vgauthd').with(
            ensure: 'running',
            enable: true
          ).that_requires("Package[#{package_name}]")
        end
      }

      it {
        is_expected.to contain_service(service_name).with(
          ensure: 'running',
          enable: true
        ).that_requires("Package[#{package_name}]")
      }
    end
  end
end
