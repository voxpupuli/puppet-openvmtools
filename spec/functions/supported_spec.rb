# frozen_string_literal: true

require 'spec_helper'

describe 'openvmtools::supported' do
  context 'On Debian 10' do
    let(:facts) do
      {
        os: {
          name: 'Debian',
          release: {
            major: '10',
          }
        }
      }
    end

    it 'returns false' do
      is_expected.to run.with_params('openvmtools').and_return(false)
    end
  end

  context 'On Debian 11' do
    let(:facts) do
      {
        os: {
          name: 'Debian',
          release: {
            major: '11',
          }
        }
      }
    end

    it 'returns true' do
      is_expected.to run.with_params('openvmtools').and_return(true)
    end
  end
end
