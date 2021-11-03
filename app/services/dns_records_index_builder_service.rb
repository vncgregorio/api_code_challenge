class DnsRecordsIndexBuilderService

  class << self

    def build(options = {})
      included = options[:included] || []
      excluded = options[:excluded] || []

      dns_records = DnsRecord.includes(:hostnames).all

      if included.any?
        dns_records = dns_records.where(id: dns_records.joins(:hostnames)
            .where(hostnames: { hostname: included })
            .group(:id)
            .having('COUNT(*) = ?', included.size)
            .select(:id)
          )
      end

      if excluded.any?
        rejected_dns_records = dns_records.where(hostnames: { hostname: excluded })
        dns_records = dns_records.where.not(id: rejected_dns_records.map(&:id))
      end

      hostname_index_records = []
      dns_records.each do |dns_record|
        removed_hostnames = included.concat(excluded).uniq
        if included.any? || excluded.any?
          dns_hostnames = dns_record.hostnames.where.not(hostnames: { hostname: removed_hostnames })
        else
          dns_hostnames = dns_record.hostnames
        end

        dns_hostnames.each do |dns_hostname|
          index = hostname_index_records.index {|hostname_index_record| hostname_index_record.hostname == dns_hostname.hostname}
          if index.nil?
            hostname_index_records << ViewObjects::HostnamesIndex.new(dns_hostname.hostname, 1)
          else
            hostname_index_records[index].count += 1
          end
        end
      end

      return ViewObjects::DnsRecordsIndex.new(dns_records.count, dns_records, hostname_index_records)
    end

  end

end
