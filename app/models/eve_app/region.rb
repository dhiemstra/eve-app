class EveApp::Region < EveApp::ApplicationRecord
  has_many :solar_systems
  has_many :constellations
end
