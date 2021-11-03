module ViewObjects
  class DnsRecordsIndex
    attr_accessor :total_records
    attr_accessor :dns_records
    attr_accessor :related_hostnames

    def initialize(total_records, dns_records, related_hostnames)
      @total_records = total_records
      @dns_records = dns_records
      @related_hostnames = related_hostnames
    end
  end
end
