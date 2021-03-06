class EveApp::Category < EveApp::ApplicationRecord
  MATERIAL            = 4
  ACCESSOIRE          = 5
  SHIP                = 6
  MODULE              = 7
  CHARGE              = 8
  BLUEPRINT           = 9
  SKILL               = 16
  COMMODITY           = 17
  DRONE               = 18
  IMPLANT             = 20
  DEPLOYABLE          = 22
  STARBASE            = 23
  ASTEROID            = 25
  APPAREL             = 30
  SUBSYSTEM           = 32
  ANCIENT_RELICS      = 34
  DECRYPTOR           = 35
  PLANET_INTERACTION  = 41
  PLANETARY_COMMODITY = 43
  STRUCTURE           = 65
  STRUCTURE_MODULE    = 66
  FIGHTER             = 87

  has_many :types
  has_many :assembly_line_details, -> { standup }, class_name: 'EveApp::AssemblyLineTypeDetailPerGroup'
  has_many :assembly_line_types, through: :assembly_line_details

  scope :published, -> { where(published: true) }
end
