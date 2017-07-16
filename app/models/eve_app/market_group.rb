class EveApp::MarketGroup < EveApp::ApplicationRecord
  BLUEPRINTS = 2
  SHIPS = 4
  SHIP_EQUIPTMENT = 9
  SHIP_MODIFICATIONS = 955
  DRONES = 157
  CAPITAL_MODULE = 1052
  DECRYPTORS = 1873
  REFINED_MATERIALS = 1335
  PILOT_SERVICES = 1942
  NANITE_PASTE = 1103

  belongs_to :parent, class_name: 'EveApp::MarketGroup', foreign_key: 'parent_group_id'
  belongs_to :root, class_name: 'EveApp::MarketGroup', foreign_key: 'root_group_id'

  has_many :types

  def root
    obj = self
    while !obj.parent.nil?
      obj = obj.parent
    end
    obj
  end
end
