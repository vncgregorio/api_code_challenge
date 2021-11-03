class ApplicationController < ActionController::API

  private

    # Response method for endpoints with default values
    def render_success_or_error(object:, success_data: nil, error_message: nil, success_status: 200, error_status: 400)
      if object.errors.empty?
        render_success(data: success_data || object, status: success_status)
      else
        render_error(object: object, message: error_message, status: error_status)
      end
    end

    # Response method for success. Serializer outputs can be send as data param and the default 200 http code
    def render_success(data: nil, status: 200)
      data = data.as_json || {}
      render json: data.as_json, status: status
    end

    # Response method for error handling. It will perform ActiveRecord validations in the object and its nested objects.
    # You can also pass a simple message for this and, if needed, change the http status code
    def render_error(object: nil, nested_objects: {}, message: nil, status: 400, data: {})
      if data.present?
        render json: data, status: status
        return
      end

      errors = []

      if object.present? and (object.errors.any? || !object.valid?)
        errors |= object.errors.is_a?(Array) ? object.errors : object.errors.full_messages
        data[:validation_errors] = object.respond_to?(:validation_errors) ? object.validation_errors : object.errors
      end

      nested_objects.each do |key, record|
        if record && record.errors.any?
          data[:validation_errors] ||= {}

          # Check for existing validation errors on object
          if data[:validation_errors].is_a?(ActiveModel::Errors)
            data[:validation_errors].add(key, record.errors)
          else
            data[:validation_errors][key] = record.errors
          end

          errors += record.errors.full_messages
        end
      end

      errors << message if message && errors.blank?
      errors.uniq!
      errors.compact!

      data[:errors] = errors

      render json: data, status: status
    end
end
