module Api
  module V1
    class DnsRecordsController < ApplicationController
      before_action :check_required_params, only: :index

      # GET /dns_records
      def index
        @dns_records_index = DnsRecordsIndexBuilderService.build(included: params[:included], excluded: params[:excluded])
        render_success(data: DnsRecordIndexBlueprint.render(@dns_records_index))
      end

      # POST /dns_records
      def create
        @dns_record = DnsRecord.new(dns_record_params)
        existing_hostnames.each do |hostname|
          @dns_record.hostnames << hostname
        end
        @dns_record.save
        render_success_or_error(object: @dns_record, success_data: DnsRecordBlueprint.render(@dns_record), success_status: :created)
      end

      private

        def dns_record_params
          params.require(:dns_records).permit(
            :ip,
            hostnames_attributes: [
              :hostname
            ]
          )
        end

        def existing_hostnames
          hostnames = []
          if dns_record_params[:hostnames_attributes].present?
            dns_record_params[:hostnames_attributes].each do |hostname_attributes|
              if hostname = Hostname.find_by_hostname(hostname_attributes['hostname'])
                hostnames << hostname
              end
            end
          end
          return hostnames
        end

        def check_required_params
          # TODO: looking at the specs, seems like the page param is mandatory but not used in the index response logic
          if params[:page].nil? || !params[:page].match(/^(\d)+$/) || params[:page].to_i <= 0
            render_error(message: 'The page param must be a positive integer', status: :unprocessable_entity)
          end

          if params[:included].present? && !params[:included].is_a?(Array)
            render_error(message: 'The included param must be an array', status: :unprocessable_entity)
          end

          if params[:excluded].present? && !params[:excluded].is_a?(Array)
            render_error(message: 'The excluded param must be an array', status: :unprocessable_entity)
          end
        end
    end
  end
end
