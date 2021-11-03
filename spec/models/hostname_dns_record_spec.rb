require 'rails_helper'

RSpec.describe HostnameDnsRecord, type: :model do
  it { should belong_to(:hostname) }
  it { should belong_to(:dns_record) }  
end
