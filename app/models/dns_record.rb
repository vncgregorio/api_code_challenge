require 'resolv'

class DnsRecord < ApplicationRecord
  has_many :hostname_dns_records
  has_many :hostnames, through: :hostname_dns_records

  accepts_nested_attributes_for :hostnames, reject_if: :hostname_already_exists

  validates :ip, presence: true, uniqueness: true, format: { with: Resolv::IPv4::Regex }

  def hostname_already_exists(hostname_attributes)
    if hostname = Hostname.find_by_hostname(hostname_attributes['hostname'])
      return true
    end
    return false
  end
end
