module EveApp
  module XmlApi
    class Classes
      class Base
        protected

        def parse_time(value)
          !value || value.starts_with?('0001') ? nil : "#{value}Z".to_time
        end
      end

      class Characters < Base
        attr_reader :id, :name, :corporation_id, :corporation_name, :alliance_id, :alliance_name, :faction_id, :faction_name

        def initialize(elem)
          @id = elem['characterID'].to_i
          @name = elem['name']
          @corporation_id = elem['corporationID'].to_i
          @corporation_name = elem['corporationName']
          @alliance_id = elem['allianceID'].to_i
          @alliance_name = elem['allianceName']
          @faction_id = elem['factionID'].to_i
          @faction_name = elem['factionName']
        end
      end

      class AccountBalance < Base
        attr_reader :id, :key, :balance

        def initialize(elem)
          @id      = elem['accountID'].to_i
          @key     = elem['accountKey'].to_i
          @balance = elem['balance'].to_f
        end
      end

      class CharacterSheet < Base
        attr_reader :id, :name, :corporation_id

        def initialize(xml)
          @id             = xml.search('//result/characterID[1]').text.to_i
          @name           = xml.search('//result/name[1]').text
          @corporation_id = xml.search('//result/corporationID[1]').text.to_i
        end
      end

      class CorporationSheet < Base
        attr_reader :id, :name, :alliance_id

        def initialize(xml)
          @id          = xml.search('//result/corporationID[1]').text.to_i
          @name        = xml.search('//result/corporationName[1]').text
          @alliance_id = xml.search('//result/allianceID[1]').text.to_i
        end
      end

      class WalletTransaction < Base
        attr_reader :created_at, :id, :quantity, :type_name, :type_id, :price,
                    :client_id, :client_name, :character_id, :station_id, :station_name, :type,
                    :transaction_for, :character_name

        def initialize(elem)
          @created_at       = parse_time(elem['transactionDateTime'])
          @id               = elem['transactionID'].to_i
          @quantity         = elem['quantity'].to_i
          @type_name        = elem['typeName']
          @type_id          = elem['typeID'].to_i
          @price            = elem['price'].to_f
          @client_id        = elem['clientID'].to_i if elem['clientID']
          @client_name      = elem['clientName']
          @character_name   = elem['characterName']
          @station_id       = elem['stationID'].to_i
          @station_name     = elem['stationName']
          @character_id     = elem['characterID'].to_i if elem['characterID'] && elem['characterID'] != '0'
          @type             = elem['transactionType']
          @transaction_for  = elem['transactionFor']
        end
      end

      class WalletJournal < Base
        attr_reader :created_at, :id, :ref_type_id, :owner1_name, :owner1_id, :owner1_type_id,
                    :owner2_name, :owner2_id, :owner2_type_id, :arg_name, :arg_id, :amount, :balance, :reason

        def initialize(elem)
          @created_at  = parse_time(elem['date'])
          @id          = elem['refID'].to_i
          @ref_type_id = elem['refTypeID'].to_i
          @owner1_id   = elem['ownerID1'].to_i if elem['ownerID1']
          @owner1_name = elem['ownerName1']
          @owner1_type = elem['owner1TypeID']
          @owner2_id   = elem['ownerID2'].to_i if elem['ownerID2']
          @owner2_name = elem['ownerName2']
          @owner2_type = elem['owner2TypeID']
          @arg_name    = elem['argName1']
          @arg_id      = elem['argID1'].to_i if elem['argID1']
          @amount      = elem['amount'].to_f
          @balance     = elem['balance'].to_f
          @reason      = elem['reason']
        end
      end

      class Blueprint < Base
        attr_reader :item_id, :location_id, :type_id, :type_name, :flag, :quantity, :te, :me, :runs

        def initialize(elem)
          @item_id     = elem['itemID'].to_i
          @location_id = elem['locationID']
          @type_id     = elem['typeID'].to_i
          @type_name   = elem['typeName']
          @flag        = elem['flagID'].to_i
          @quantity    = elem['quantity'].to_i
          @te          = elem['timeEfficiency'].to_i
          @me          = elem['materialEfficiency'].to_i
          @runs        = elem['runs'].to_i
        end
      end

      class Asset < Base
        attr_accessor :container, :parent
        attr_reader :item_id, :type_id, :location_id, :quantity, :flag, :repacked, :raw_quantity

        def initialize(elem)
          @container = false
          @parent = nil
          @item_id = elem['itemID'].to_i
          @type_id = elem['typeID'].to_i
          @location_id = elem['locationID'].to_i
          @quantity = elem['quantity'].to_i
          @flag = elem['flag'].to_i
          @repacked = elem['singleton'].to_i
          @raw_quantity = elem['rawQuantity'].to_i
        end

        def container?
          !!container
        end

        def parent?
          !!parent
        end
      end

      class MarketOrder < Base
        attr_reader :order_id, :character_id, :station_id, :volume_entered, :volume_remaining, :minimum_volume,
                    :state, :type_id, :range, :account_key, :duration, :escrow, :price, :bid, :issued_at

        def initialize(elem) #:nodoc:
          @order_id = elem['orderID'].to_i
          @character_id = elem['charID'].to_i
          @station_id = elem['stationID'].to_i
          @volume_entered = elem['volEntered'].to_i
          @volume_remaining = elem['volRemaining'].to_i
          @minimum_volume = elem['minVolume'].to_i
          @state = case elem['orderState'].to_i
          when 0
            'Active'
          when 1
            'Closed'
          when 2
            'Expired'
          when 3
            'Cancelled'
          when 4
            'Pending'
          when 5
            'Character Deleted'
          end
          @type_id = elem['typeID'].to_i
          @range = elem['range'].to_i
          @account_key = elem['accountKey'].to_i
          @escrow = elem['escrow'].to_f
          @price = elem['price'].to_f
          @bid = elem['bid'] == '1'
          @duration = elem['duration'].to_i
          @issued_at = parse_time(elem['issued'])
        end
      end

      class IndustryJob < Base
        attr_reader :job_id, :installer_id, :installer_name, :facility_id, :system_id, :system_name,
                    :station_id, :activity_id, :blueprint_id, :blueprint_type_id, :blueprint_type_name,
                    :blueprint_location_id, :output_location_id, :runs, :cost, :team_id, :licensed_runs,
                    :probability, :product_type_id, :product_type_name, :status, :duration, :start_date,
                    :end_date, :pause_date, :completed_date, :completed_character_id, :successful_runs

        def initialize(elem)
          @job_id = elem['jobID'].to_i    # "306488326"
          @installer_id = elem['installerID'].to_i    # "1663516939"
          @installer_name = elem['installerName']    # "GaIIente Slave"
          @facility_id = elem['facilityID'].to_i    # "1022215707239"
          @system_id = elem['solarSystemID'].to_i    # "30001363"
          @system_name = elem['solarSystemName']    # "Sobaseki"
          @station_id = elem['stationID'].to_i    # "1022182744039"
          @activity_id = elem['activityID'].to_i    # "1"
          @blueprint_id = elem['blueprintID'].to_i    # "1022215694764"
          @blueprint_type_id = elem['blueprintTypeID'].to_i    # "22545"
          @blueprint_type_name = elem['blueprintTypeName']    # "Hulk Blueprint"
          @blueprint_location_id = elem['blueprintLocationID'].to_i    # "1022215707239"
          @output_location_id = elem['outputLocationID'].to_i    # "1022215707239"
          @runs = elem['runs'].to_i    # "1"
          @cost = elem['cost'].to_f    # "8920512.00"
          @team_id = elem['teamID'].to_i    # "0"
          @licensed_runs = elem['licensedRuns'].to_i    # "1"
          @probability = elem['probability'].to_f    # "1"
          @product_type_id = elem['productTypeID'].to_i
          @product_type_name = elem['productTypeName']
          @status = elem['status'].to_i
          @duration = elem['timeInSeconds'].to_i
          @start_date = parse_time(elem['startDate'])
          @end_date = parse_time(elem['endDate'])
          @pause_date = parse_time(elem['pauseDate'])
          @completed_date = parse_time(elem['completedDate'])
          @completed_character_id = elem['completedCharacterID'].to_i
          @successful_runs = elem['successfulRuns'].to_i
        end
      end

      class CorporateMemberTracking < Base
        attr_reader :character_id, :name, :start_date, :base_id, :base, :title, :logon_date, :logoff_date, :location_id, :location, :ship_type_id, :ship_type, :roles, :grantable_roles

        def initialize(elem)
          @character_id = elem['characterID'].to_i
          @name = elem['name']
          @start_date = parse_time(elem['startDateTime'])
          @base_id = elem['baseID'].to_i
          @base = elem['base']
          @title = elem['title']
          @logon_date = parse_time(elem['logonDateTime'])
          @logoff_date = parse_time(elem['logoffDateTime'])
          @location_id = elem['locationID'].to_i > 0 ? elem['locationID'].to_i : nil
          @location = elem['location'].presence
          @ship_type_id = elem['shipTypeID'].to_i
          @ship_type = elem['shipType']
          @roles = elem['roles']
          @grantable_roles = elem['grantableRoles']
        end
      end
    end
  end
end
