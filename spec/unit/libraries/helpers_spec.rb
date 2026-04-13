# frozen_string_literal: true

require_relative '../../spec_helper'
require_relative '../../../libraries/helpers'

describe Certificate::Cookbook::Helpers do
  subject { Class.new { include Certificate::Cookbook::Helpers }.new }

  describe '#default_cert_path' do
    context 'on redhat' do
      it 'returns /etc/pki/tls' do
        allow(subject).to receive(:platform_family?).with('rhel', 'fedora', 'amazon').and_return(true)
        expect(subject.default_cert_path).to eq('/etc/pki/tls')
      end
    end

    context 'on amazon' do
      it 'returns /etc/pki/tls' do
        allow(subject).to receive(:platform_family?).with('rhel', 'fedora', 'amazon').and_return(true)
        expect(subject.default_cert_path).to eq('/etc/pki/tls')
      end
    end

    context 'on ubuntu' do
      it 'returns /etc/ssl' do
        allow(subject).to receive(:platform_family?).with('rhel', 'fedora', 'amazon').and_return(false)
        expect(subject.default_cert_path).to eq('/etc/ssl')
      end
    end
  end
end
