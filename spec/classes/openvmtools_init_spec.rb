# frozen_string_literal: true

require 'spec_helper'

describe 'openvmtools', type: 'class' do
  context 'on a non-supported os, non-vmware platform' do
    let(:params) { {} }
    let :facts do
      {
        virtual:                   'foo',
        osfamily:                  'foo',
        operatingsystem:           'foo',
        operatingsystemrelease:    '1',
        operatingsystemmajrelease: '1',
        os:                        {
          family:  'foo',
          name:    'foo',
          release: {
            full:  '1.1',
            major: '1',
            minor: '1'
          }
        }
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
        virtual:                   'foo',
        osfamily:                  'RedHat',
        operatingsystem:           'RedHat',
        operatingsystemrelease:    '7.0',
        operatingsystemmajrelease: '7',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        }
      }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a non-supported RedHat os, vmware platform' do
    let(:params) { {} }
    let :facts do
      {
        virtual:                   'vmware',
        osfamily:                  'RedHat',
        operatingsystem:           'RedHat',
        operatingsystemrelease:    '6.0',
        operatingsystemmajrelease: '6',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '6.0',
            major: '6',
            minor: '0'
          }
        }
      }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported RedHat os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        virtual:                   'vmware',
        osfamily:                  'RedHat',
        operatingsystem:           'RedHat',
        operatingsystemrelease:    '7.0',
        operatingsystemmajrelease: '7',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        }
      }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it {
      should contain_service('vmtoolsd').with(
        ensure:    'running',
        enable:    true,
        hasstatus: true,
        pattern:   'vmtoolsd',
        require:   'Package[open-vm-tools]'
      )
    }
  end

  context 'on a supported Debian os, vmware platform, default parameters' do
    let(:params) { {} }
    let :facts do
      {
        virtual:                   'vmware',
        osfamily:                  'Debian',
        operatingsystem:           'Ubuntu',
        operatingsystemrelease:    '14.04',
        operatingsystemmajrelease: '14',
        os:                        {
          family:  'Debian',
          name:    'Ubuntu',
          release: {
            full:  '14.04',
            major: '14',
            minor: '04'
          }
        }
      }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it {
      should contain_service('open-vm-tools').with(
        ensure:    'running',
        enable:    true,
        hasstatus: false,
        pattern:   'vmtoolsd',
        require:   'Package[open-vm-tools]'
      )
    }
  end

  context 'on a supported RedHat os, vmware platform, custom parameters' do
    let :facts do
      {
        virtual:                   'vmware',
        osfamily:                  'RedHat',
        operatingsystem:           'RedHat',
        operatingsystemrelease:    '7.0',
        operatingsystemmajrelease: '7',
        os:                        {
          family:  'RedHat',
          name:    'RedHat',
          release: {
            full:  '7.0',
            major: '7',
            minor: '0'
          }
        }
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
