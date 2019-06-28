# frozen_string_literal: true

require 'spec_helper'

describe 'openvmtools', type: 'class' do
  context 'on a non-supported os, non-vmware platform' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'foo',
        operatingsystemmajrelease: '1',
        operatingsystemrelease:    '1',
        os:                        {
          family:  'foo',
          name:    'foo',
          release: {
            full:  '1.1',
            major: '1',
            minor: '1'
          }
        },
        osfamily:                  'foo',
        virtual:                   'foo'
      }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vgauthd') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported os, non-vmware platform' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'RedHat',
        operatingsystemmajrelease: '7',
        operatingsystemrelease:    '7.0',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        },
        osfamily:                  'RedHat',
        virtual:                   'foo'
      }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vgauthd') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported RedHat 6 os, vmware platform' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'RedHat',
        operatingsystemmajrelease: '6',
        operatingsystemrelease:    '6.0',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '6.0',
            major: '6',
            minor: '0'
          }
        },
        osfamily:                  'RedHat',
        virtual:                   'vmware'
      }
    end
    it { should contain_class('epel') }
    it {
      should contain_yumrepo('epel').that_comes_before('Package[open-vm-tools]')
    }
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it {
      should contain_service('vgauthd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
      )
    }
    it {
      should contain_service('vmtoolsd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
      )
    }
  end

  context 'on a supported RedHat 7 os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'RedHat',
        operatingsystemmajrelease: '7',
        operatingsystemrelease:    '7.0',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        },
        osfamily:                  'RedHat',
        virtual:                   'vmware'
      }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it {
      should contain_service('vgauthd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
      )
    }
    it {
      should contain_service('vmtoolsd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
      )
    }
  end

  context 'on a supported Debian 14 os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'Ubuntu',
        operatingsystemmajrelease: '14',
        operatingsystemrelease:    '14.04',
        os:                        {
          family:  'Debian',
          name:    'Ubuntu',
          release: {
            full:  '14.04',
            major: '14',
            minor: '04'
          }
        },
        osfamily:                  'Debian',
        virtual:                   'vmware'
      }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it {
      should contain_service('open-vm-tools').with(
        ensure:    'running',
        enable:    true,
        hasstatus: false,
        require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
      )
    }
  end

  context 'on a supported FreeBSD 10 os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'FreeBSD',
        operatingsystemmajrelease: '10',
        operatingsystemrelease:    '10.4-RELEASE',
        os:                        {
          family:  'FreeBSD',
          name:    'FreeBSD',
          release: {
            full:  '10.4-RELEASE',
            major: '10',
            minor: '4'
          }
        },
        osfamily:                  'FreeBSD',
        virtual:                   'vmware'
      }
    end
    it { should contain_package('open-vm-tools-nox11') }
    it { should_not contain_package('open-vm-tools') }
    it {
      should contain_service('vmware_guestd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   "[Package[open-vm-tools-nox11]\
{:name=>\"open-vm-tools-nox11\"}]"
      )
    }
  end

  context 'on a supported FreeBSD 11 os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        operatingsystem:           'FreeBSD',
        operatingsystemmajrelease: '11',
        operatingsystemrelease:    '11.2-RELEASE',
        os:                        {
          family:  'FreeBSD',
          name:    'FreeBSD',
          release: {
            full:  '11.2-RELEASE',
            major: '11',
            minor: '2'
          }
        },
        osfamily:                  'FreeBSD',
        virtual:                   'vmware'
      }
    end
    it { should contain_package('open-vm-tools-nox11') }
    it { should_not contain_package('open-vm-tools') }
    it {
      should contain_service('vmware_guestd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        require:   "[Package[open-vm-tools-nox11]\
{:name=>\"open-vm-tools-nox11\"}]"
      )
    }
  end

  context 'on a supported RedHat 7 os, vmware platform, custom parameters' do
    let :facts do
      {
        operatingsystem:           'RedHat',
        operatingsystemmajrelease: '7',
        operatingsystemrelease:    '7.0',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        },
        osfamily:                  'RedHat',
        virtual:                   'vmware'
      }
    end

    describe 'ensure => absent' do
      let(:params) { { ensure: 'absent' } }
      it { should contain_package('open-vm-tools').with_ensure('absent') }
      it { should contain_service('vgauthd').with_ensure('stopped') }
      it { should contain_service('vmtoolsd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) { { with_desktop: true } }
      it {
        should contain_package('open-vm-tools-desktop').with_ensure('present')
      }
    end

    describe 'uninstall_vmware_tools => true' do
      let(:params) { { uninstall_vmware_tools: true } }
      it {
        should contain_package('VMwareTools').with_ensure('absent')
      }
    end
  end
  context 'on a supported FreeBSD 11 os, vmware platform, custom parameters' do
    let :facts do
      {
        operatingsystem:           'FreeBSD',
        operatingsystemmajrelease: '11',
        operatingsystemrelease:    '11.2-RELEASE',
        os:                        {
          family:  'FreeBSD',
          name:    'FreeBSD',
          release: {
            full:  '11.2-RELEASE',
            major: '11',
            minor: '2'
          }
        },
        osfamily:                  'FreeBSD',
        virtual:                   'vmware'
      }
    end

    describe 'ensure => absent' do
      let(:params) { { ensure: 'absent' } }
      it { should contain_package('open-vm-tools-nox11').with_ensure('absent') }
      it { should contain_service('vmware_guestd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) { { with_desktop: true } }
      it { should contain_package('open-vm-tools') }
      it { should_not contain_package('open-vm-tools-nox11') }
      it {
        should contain_service('vmware_guestd').with(
          ensure:    'running',
          enable:    true,
          hasstatus: true,
          require:   '[Package[open-vm-tools]{:name=>"open-vm-tools"}]'
        )
      }
    end
  end
end
