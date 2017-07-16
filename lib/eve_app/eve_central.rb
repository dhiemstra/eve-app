require 'rest-client'
require 'multi_json'

module EveApp
  class EveCentral
    ENDPOINT = 'http://api.eve-central.com/api/marketstat/json'
    MAX_TRIES = 3

    def self.fetch(type_ids, system_id=EveApp::SolarSystem::JITA)
      type_ids = Array[type_ids].flatten
      results = []
      type_ids.in_groups_of(100, false) do |group|
        results += fetch_prices(group, system_id)
      end
      results
    end

    def self.fetch_prices(type_ids, system_id=EveApp::SolarSystem::JITA)
      type_ids = Array[type_ids].flatten
      json = request(generate_url(ENDPOINT, type_ids, system_id))
      parse_response(json)
    end

    def self.generate_url(endpoint, type_ids, system_id, extra={})
      type_ids = Array[type_ids].flatten
      params = type_ids.map { |id| "typeid=#{id}" }
      params.push("usesystem=#{system_id}")
      extra.each do |key,val|
        params.push("#{key}=#{val}")
      end
      "#{endpoint}?#{params.join('&')}"
    end

    def self.request(url)
      response = nil

      1.upto(MAX_TRIES) do |try|
        begin
          response = RestClient.get(url, user_agent: 'EveBuddy 0.1')
          break if response
        rescue StandardError => e
          puts "==================================================="
          puts "Error received #{e.class}: #{e.message}"
          puts url.to_s
          puts "==================================================="
          break
        end
      end

      MultiJson.load(response.body, symbolize_keys: true) rescue {}
    end

    def self.parse_response(json)
      json.map { |row|
        OpenStruct.new(
          type_id:         row[:all][:forQuery][:types].first,
          solar_system_id: row[:all][:forQuery][:systems].first,
          buy:             PriceResult.new(:buy, row[:buy]),
          sell:            PriceResult.new(:sell, row[:sell])
        )
      }
    end

    class PriceResult
      attr_reader :type, :volume, :average, :max, :min, :stddev, :median, :percentile

      def initialize(type, data)
        @type = type
        @volume = data[:volume].to_i
        @average = (data[:avg].to_f * 100).round
        @max = (data[:max].to_f * 100).round
        @min = (data[:min].to_f * 100).round
        @stddev = (data[:stdDev].to_f * 100).round
        @median = (data[:median].to_f * 100).round
      end
    end
  end
end
