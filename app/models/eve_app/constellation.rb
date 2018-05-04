class EveApp::Constellation < EveApp::ApplicationRecord
  belongs_to :region
  has_many :solar_systems
end
