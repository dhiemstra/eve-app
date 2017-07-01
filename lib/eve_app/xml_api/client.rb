require 'fileutils'
require 'net/http'
require 'rest-client'

module EveApp
  module XmlApi
    class Client
      API_HOST = 'https://api.eveonline.com'
      MAX_TRIES = 4
      REQUEST_TIMEOUT = 60

      attr_reader :key_id, :vcode
      attr_accessor :save_responses, :character_id

      def initialize(key_id, vcode)
        @key_id = key_id
        @vcode = vcode
        @save_responses = false
        @character_id = nil
      end

      def method_missing(name, params={})
        call = Calls.const_get(name.to_s.camelize)
        params[:last_id] ? walk(call, params) : request(call, params)
      # rescue NameError
      #   super
      end

      private

      def walk(call, params={})
        last_id = params.delete(:last_id)
        from_id = nil
        collection = call.new

        50.times do
          page = request(call, params.merge(rowCount: 1000, fromID: from_id))
          page.results.reject! { |r| r.id <= last_id }

          if collection.cached_until.nil? || collection.cached_until > page.cached_until
            collection.cached_until = page.cached_until
          end
          break if page.blank?

          collection.merge(page)
          from_id = page.ids.min
          break if from_id <= last_id
        end

        collection
      end

      def request(call, params={})
        params = params.merge({ rowCount: 500, keyID: key_id, vCode: vcode })
        params[:characterID] = character_id if character_id
        response = nil

        1.upto(MAX_TRIES) do |try|
          begin
            response = RestClient::Request.execute(
              method:  :get,
              url:     "#{API_HOST}#{call.endpoint}",
              timeout: REQUEST_TIMEOUT,
              headers: { params:  params }
            )
          # rescue RestClient::Exception => ex
          #   error = Calls::ErrorResponse.new(ex, call, params)
          #   raise error
          end
          break if response
        end

        if save_responses
          folder = Rails.root.join('tmp', call.to_s.underscore)
          FileUtils.mkdir_p(folder)
          File.write(folder.join("#{Time.now.to_i.to_s}.xml"), response.body)
        end

        xml = Nokogiri::XML(response.body)
        call.new(xml)
      rescue Errno::ECONNRESET, Net::ReadTimeout, RestClient::Exceptions::ReadTimeout
        raise ConnectionError, $!.message
      end
    end
  end
end
