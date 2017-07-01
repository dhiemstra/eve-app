class EveApp::SolarSystem < EveApp::ApplicationRecord
  belongs_to :region

  has_many :stations
end

