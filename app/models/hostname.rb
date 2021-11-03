class Hostname < ApplicationRecord
  has_many :hostname_dns_records
  has_many :dns_records, through: :hostname_dns_records

  validates :hostname, presence: true, uniqueness: true, hostname: true
end
