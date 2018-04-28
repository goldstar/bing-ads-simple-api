require 'csv'
require 'zip'

module BingAdsSimpleApi
  module Reports
    class Base

      def self.report_type(value)
        @report_type = value
      end

      def report_type=(value)
        @report_type = value
      end

      def report_type
        self.class.instance_variable_get("@report_type")
      end

      def self.report_definition(value)
        @report_definition = value
      end

      def report_definition=(value)
        @report_definition = value
      end

      def report_definition
        @report_definition || self.class.instance_variable_get("@report_definition")
      end

      def self.integer_columns(*columns)
        @integer_columns = columns
      end

      def integer_columns
        self.class.instance_variable_get("@integer_columns") || []
      end

      def self.float_columns(*columns)
        @float_columns = columns
      end

      def float_columns
        self.class.instance_variable_get("@float_columns") || []
      end

      def self.currency_columns(*columns)
        @currency_columns = columns
      end

      def currency_columns
        self.class.instance_variable_get("@currency_columns") || []
      end

      def self.date_columns(*columns)
        @date_columns = columns
      end

      def date_columns
        self.class.instance_variable_get("@date_columns") || []
      end

      def request_message
        o = report_definition
        tns({
          report_request: {
            exclude_column_headers: 'false',
            exclude_report_footer: 'true',
            exclude_report_header: 'true',
            format: 'Csv',
            language:                   o[:language] || 'English',
            report_name:                o[:report_name] || 'BingAdsSimpleApiReport',
            return_only_complete_data:  o[:return_only_complete_data] || 'false',
            aggregation:                o[:aggregation],
            columns: {
              "tns:#{report_type}ReportColumn" => o[:columns]
            },
            scope: {
              "tns:AccountIds" => { 'arr:long' => BingAdsSimpleApi.customer_account_id }
            }.merge(o[:scope] || {}),
            time: o[:time]
          },
          :attributes! => {
            report_request: {
              "i:type" => "tns:#{report_type}ReportRequest",
              "i:nil" => 'false',
            }
          }
        })
      end

      def service
        @service ||= Services::Reporting.new()
      end

      def download
        report_id = service.submit_generate_report(request_message)
        until url = service.poll_generate_report(report_id)
          # TODO: timeout
          sleep(1)
        end
        uri = URI(url)
        response = Net::HTTP.get_response(uri)
        csv_string = ''

        Zip::InputStream.open(StringIO.new(response.body)) do |io|
          entry = io.get_next_entry # assumes only one file in zip
          csv_string = io.read
        end

        # Not sure what's going on but the stream often starts
        # some characters that aren't part of the csv file
        csv_string.gsub(/^[^"]*/,'').gsub(/\r/,'')
      end

      def csv
        @csv_string ||= download
        CSV.parse(@csv_string, {:headers => true, :header_converters => lambda{ |h| h.gsub(/([a-z])([A-Z])/){ |g| "#{g[0]} #{g[1]}"}.downcase.gsub(' ','_').to_sym }})
      end

      def to_a
        a = csv.map(&:to_h); # turn each row into a plain hash

        # TODO: move these into CSV converters
        a.each do |row|
          # Transform integer columns
          integer_columns.each do |column|
            row[column] = row[column].to_s.strip.to_i if row[column]
          end

          # Transform float columns
          float_columns.each do |column|
            row[column] = row[column].to_s.strip.to_f if row[column]
          end

          date_columns.each do |column|
            row[column] = Date.parse(row[column].to_s.strip) if row[column]
          end
        end
        return a
      end

    end
  end
end
