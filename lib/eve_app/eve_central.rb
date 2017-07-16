module EveApp
  class EveCentral
    ENDPOINT = 'http://api.eve-central.com/api/marketstat'
    QUICKLOOK_ENDPOINT = 'http://api.eve-central.com/api/quicklook'
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
      doc = request(generate_url(ENDPOINT, type_ids, system_id))
      parse_marketstat_response(doc)
    end

    def self.quicklook(type_ids, system_id=EveApp::SolarSystem::JITA)
      type_ids = Array[type_ids].flatten
      orders = type_ids.map do |type_id|
        doc = request(generate_url(QUICKLOOK_ENDPOINT, type_id, system_id, sethours: 6))
        parse_quicklook_response(type_id, doc)
      end
      orders.flatten
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

      Nokogiri::XML(response.body)
    end

    def self.parse_marketstat_response(xml)
      xml.search("//marketstat/type").map { |row|
        OpenStruct.new(
          type_id: row['id'].to_i,
          buy:     PriceResult.new(:buy, row.at('buy')),
          sell:    PriceResult.new(:sell, row.at('sell')),
          #all:     PriceResult.new(:all, row.at('all'))
        )
      }
    end

    def self.parse_quicklook_response(type_id, xml)
      orders = []
      xml.search("//quicklook/sell_orders/order").each do |order|
        orders.push OrderResult.new(type_id, :sell, order)
      end
      xml.search("//quicklook/buy_orders/order").each do |order|
        orders.push OrderResult.new(type_id, :buy, order)
      end
      orders
    end

    class OrderResult
      attr_reader :id, :order_type, :type_id, :station_id, :region_id, :volume_remaining, :minimum_volume, :range, :price, :expires_at, :reported_at

      def initialize(type_id, order_type, order)
        @id = order['id']
        @order_type = order_type
        @type_id = type_id
        @station_id = order.search('station').text
        @region_id = order.search('region').text
        @volume_remaining = order.search('vol_remain').text
        @minimum_volume = order.search('vol_remain').text
        @range = order.search('range').text
        @price = BigDecimal.new(order.search('price').text)
        @expires_at =  order.search('expires').text.to_date
        @reported_at = "#{Date.today.year}-#{order.search('reported_time').text}Z".to_time
      end
    end

    class PriceResult
      attr_reader :type, :volume, :average, :max, :min, :stddev, :median, :percentile

      def initialize(type, entry)
        @type = type
        @volume = entry.at('volume').text.to_i
        @average = entry.at('avg').text.to_f
        @max = entry.at('max').text.to_f
        @min = entry.at('min').text.to_f
        @stddev = entry.at('stddev').text.to_f
        @median = entry.at('median').text.to_f
        @percentile = entry.at('percentile').text.to_f
      end
    end
  end
end
