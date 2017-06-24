class EveApp::Region < EveApp::ApplicationRecord
  has_many :solar_systems, class_name: 'EveApp::SolarSystem'
end
