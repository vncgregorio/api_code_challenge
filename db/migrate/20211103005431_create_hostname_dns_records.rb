class CreateHostnameDnsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :hostname_dns_records do |t|
      t.references :dns_record, null: false, foreign_key: true
      t.references :hostname, null: false, foreign_key: true

      t.timestamps
    end
  end
end
