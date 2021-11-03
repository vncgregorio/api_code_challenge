class DnsRecordBlueprint < Blueprinter::Base
  fields :id

  view :index do
    field :ip, name: :ip_address
  end
end
