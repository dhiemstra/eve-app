module EveApp
  module XmlApi
    class Calls
      class Base
        class_attribute :endpoint
        class_attribute :selector
        class_attribute :class_name

        self.selector = '//rowset/row'

        attr_reader :xml, :results
        attr_accessor :cached_until

        delegate :blank?, :present?, :any?, to: :results

        def initialize(xml=nil)
          if xml
            @xml = xml
            @results = xml.search(selector).map { |row| class_name.new(row) }
            @cached_until = (xml.search('cachedUntil').text + 'Z').to_time
          else
            @results = []
          end
        end

        def merge(call)
          @results += call.results
        end

        def ids
          @results.map(&:id)
        end

        def error?
          false
        end
      end

      class Characters < Base
        self.class_name = Classes::Characters
        self.endpoint = '/account/Characters.xml.aspx'
      end

      class Sheet < Base
        attr_reader :sheet

        def initialize(xml)
          @xml = xml
          @sheet = class_name.new(xml)
        end
      end
      class CharacterSheet < Sheet
        self.class_name = Classes::CharacterSheet
        self.endpoint = '/char/CharacterSheet.xml.aspx'
      end
      class CorporationSheet < Sheet
        self.class_name = Classes::CorporationSheet
        self.endpoint = '/corp/CorporationSheet.xml.aspx'
      end

      class AccountBalance < Base
        self.class_name = Classes::AccountBalance
      end
      class PersonalAccountBalance < AccountBalance
        self.endpoint = '/char/AccountBalance.xml.aspx'
      end
      class CorporateAccountBalance < AccountBalance
        self.endpoint = '/corp/AccountBalance.xml.aspx'
      end

      class WalletTransactions < Base
        self.class_name = Classes::WalletTransaction
      end
      class PersonalWalletTransactions < WalletTransactions
        self.endpoint = '/char/WalletTransactions.xml.aspx'
      end
      class CorporateWalletTransactions < WalletTransactions
        self.endpoint = '/corp/WalletTransactions.xml.aspx'
      end

      class WalletJournals < Base
        self.class_name = Classes::WalletJournal
      end
      class PersonalWalletJournals < WalletJournals
        self.endpoint = '/char/WalletJournal.xml.aspx'
      end
      class CorporateWalletJournals < WalletJournals
        self.endpoint = '/corp/WalletJournal.xml.aspx'
      end

      class Blueprints < Base
        self.class_name = Classes::Blueprint
      end
      class PersonalBlueprints < Blueprints
        self.endpoint = '/char/Blueprints.xml.aspx'
      end
      class CorporateBlueprints < Blueprints
        self.endpoint = '/corp/Blueprints.xml.aspx'
      end

      class MarketOrders < Base
        self.class_name = Classes::MarketOrder
      end
      class PersonalMarketOrders < MarketOrders
        self.endpoint = '/char/MarketOrders.xml.aspx'
      end
      class CorporateMarketOrders < MarketOrders
        self.endpoint = '/corp/MarketOrders.xml.aspx'
      end

      class IndustryJobs < Base
        self.class_name = Classes::IndustryJob
      end
      class PersonalIndustryJobs < IndustryJobs
        self.endpoint = '/char/IndustryJobs.xml.aspx'
      end
      class CorporateIndustryJobs < IndustryJobs
        self.endpoint = '/corp/IndustryJobs.xml.aspx'
      end
      class PersonalIndustryJobHistory < IndustryJobs
        self.endpoint = '/char/IndustryJobsHistory.xml.aspx'
      end
      class CorporateIndustryJobHistory < IndustryJobs
        self.endpoint = '/corp/IndustryJobsHistory.xml.aspx'
      end

      class AssetList < Base
        attr_reader :assets

        def initialize(xml)
          @assets = []
          parse_rows(xml.search("//rowset[@name='assets']/row"))
          @cached_until = (xml.search('cachedUntil').text + 'Z').to_time
        end

        def parse_rows(rows, parent=nil)
          rows.each do |container|
            asset = Classes::Asset.new(container)
            asset.container = container.children.any?
            asset.parent = parent if parent
            parse_rows(container.search("rowset/row"), asset) if asset.container?
            @assets << asset
          end
        end
      end
      class PersonalAssetList < AssetList
        self.endpoint = '/char/AssetList.xml.aspx'
      end
      class CorporateAssetList < AssetList
        self.endpoint = '/corp/AssetList.xml.aspx'
      end

      class CorporateMemberTracking < Base
        self.class_name = Classes::CorporateMemberTracking
        self.endpoint = '/corp/MemberTracking.xml.aspx'
      end

      class ErrorResponse < Base
        attr_reader :exception, :call, :params

        def initialize(exception, call=nil, params={})
          @exception = exception
          @call = call
          @params = params
        end

        def error?
          true
        end

        def title
          exception.http_body.scan(/<title>(.+?)<\/title>/).flatten[0]
        end

        def to_s
          puts "================================"
          puts "API Error: #{exception.class}"
          puts "title: #{title}"
          puts "body: #{exception.http_body}"
          puts "call: #{call}"
          puts "params: #{params.inspect}"
          puts "================================"
        end
      end
    end
  end
end
