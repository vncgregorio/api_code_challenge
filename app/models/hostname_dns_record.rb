class HostnameDnsRecord < ApplicationRecord
  belongs_to :dns_record, optional: false
  belongs_to :hostname, optional: false
end
