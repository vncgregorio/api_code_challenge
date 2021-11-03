class DnsRecordIndexBlueprint < Blueprinter::Base
  field :total_records

  field :dns_records, name: :records do |dns_records_index, options|
    DnsRecordBlueprint.render_as_json(dns_records_index.dns_records, view: :index)
  end

  field :related_hostnames do |dns_records_index, options|
    HostnameBlueprint.render_as_json(dns_records_index.related_hostnames)
  end
end
