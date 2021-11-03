require 'rails_helper'

RSpec.describe DnsRecord, type: :model do
  it { should have_many(:hostname_dns_records) }
  it { should have_many(:hostnames).through(:hostname_dns_records) }

  it{ should accept_nested_attributes_for :hostnames }

  describe 'validations for ip' do
    it { should validate_presence_of(:ip) }
    it { should validate_uniqueness_of(:ip) }

    context 'when format is not valid' do
      let(:subject) { described_class.new(ip: '1111.111.111.111') }
      it { is_expected.not_to be_valid }
    end

    context 'when format is valid' do
      let(:subject) { described_class.new(ip: '192.168.1.1') }
      it { is_expected.to be_valid }
    end
  end
end
