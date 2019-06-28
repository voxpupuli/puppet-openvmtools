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
      it { should contain_service('vmtoolsd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) { { with_desktop: true } }
      it {
        should contain_package('open-vm-tools-desktop').with_ensure('present')
      }
    end
  end
end
