require 'rails_helper'

RSpec.describe Hostname, type: :model do
  it { should have_many(:hostname_dns_records) }
  it { should have_many(:dns_records).through(:hostname_dns_records) }

  describe 'validations for hostname' do
    it { should validate_presence_of(:hostname) }
    it { should validate_uniqueness_of(:hostname) }

    context 'when not valid' do
      let(:subject) { described_class.new(hostname: '_host') }
      it { is_expected.not_to be_valid }
    end

    context 'when valid' do
      let(:subject) { described_class.new(hostname: 'lorem.com') }
      it { is_expected.to be_valid }
    end
  end
end
