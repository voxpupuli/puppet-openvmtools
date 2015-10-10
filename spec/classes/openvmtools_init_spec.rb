require 'spec_helper'

describe 'openvmtools', :type => 'class' do

  context 'on a non-supported osfamily' do
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, non-vmware platform, RedHat' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'foo',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, non-vmware platform, FreeBSD' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'foo',
      :osfamily                  => 'FreeBSD',
      :operatingsystem           => 'FreeBSD',
      :operatingsystemrelease    => '10.0',
      :operatingsystemmajrelease => '10'
    }
    end
    it { should_not contain_package('open-vm-tools-nox11') }
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_service('vmware_guestd') }
  end

  context 'on a supported osfamily, vmware platform, non-supported operatingsystem' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '6.0',
      :operatingsystemmajrelease => '6'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, vmware platform, default parameters, RedHat' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should contain_service('vmtoolsd').with(
      :ensure    => 'running',
      :enable    => true,
      :hasstatus => true,
      :pattern   => 'vmtoolsd',
      :require   => 'Package[open-vm-tools]'
    )}
  end

  context 'on a supported osfamily, vmware platform, default parameters, Debian' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'Debian',
      :operatingsystem           => 'Ubuntu',
      :operatingsystemrelease    => '14.04',
      :operatingsystemmajrelease => '14.04'
    }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should contain_service('open-vm-tools').with(
      :ensure    => 'running',
      :enable    => true,
      :hasstatus => false,
      :pattern   => 'vmtoolsd',
      :require   => 'Package[open-vm-tools]'
    )}
  end

  context 'on a supported osfamily, vmware platform, default parameters, FreeBSD' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'FreeBSD',
      :operatingsystem           => 'FreeBSD',
      :operatingsystemrelease    => '10.0',
      :operatingsystemmajrelease => '10'
    }
    end
    it { should contain_package('open-vm-tools-nox11') }
    it { should_not contain_package('open-vm-tools') }
    it { should contain_service('vmware_guestd').with(
      :ensure    => 'running',
      :enable    => true,
      :hasstatus => true,
      :pattern   => 'vmtoolsd',
      :require   => 'Package[open-vm-tools-nox11]'
    )}
  end
    
  context 'on a supported operatingsystem, vmware platform, custom parameters, RedHat' do
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_package('open-vm-tools').with_ensure('absent') }
      it { should contain_service('vmtoolsd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) {{ :with_desktop => true }}
      it { should contain_package('open-vm-tools-desktop').with_ensure('present') }
    end
  end

  context 'on a supported operatingsystem, vmware platform, custom parameters, FreeBSD' do
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'FreeBSD',
      :operatingsystem           => 'FreeBSD',
      :operatingsystemrelease    => '10.0',
      :operatingsystemmajrelease => '10'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_package('open-vm-tools-nox11').with_ensure('absent') }
      it { should contain_service('vmware_guestd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) {{ :with_desktop => true }}
      it { should contain_package('open-vm-tools').with_ensure('present') }
    end
  end

end
