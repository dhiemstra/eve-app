class EveApp::Category < EveApp::ApplicationRecord
  MATERIAL = 4
  ACCESSOIRE = 5
  SHIP = 6
  MODULE = 7
  CHARGE = 8
  BLUEPRINT = 9
  SKILL = 16
  DATACORE = 17
  DRONE = 18
  DEPLOYABLE = 22
  STARBASE = 23
  IMPLANT = 20
  APPAREL = 30
  SUBSYSTEM = 32
  ANCIENT_RELICS = 34
  DECRYPTOR = 35
  PLANET_INTERACTION = 41
  COMMODITY = 43
  STRUCTURE = 65
  STRUCTURE_MODULE = 66
  FIGHTER = 87

  has_many :types

  scope :published, -> { where(published: true) }
end
