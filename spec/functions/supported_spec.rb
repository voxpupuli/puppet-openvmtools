# frozen_string_literal: true

require 'spec_helper'

describe 'openvmtools::supported' do
  on_supported_os.each do |os, os_facts|
    context "On #{os}" do
      let(:facts) { os_facts.merge(virtual: 'vmware') }

      it 'returns true' do
        is_expected.to run.with_params('openvmtools').and_return(true)
      end
    end
  end
end
