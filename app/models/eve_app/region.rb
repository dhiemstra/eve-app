class EveApp::Region < EveApp::ApplicationRecord
  has_many :solar_systems, class_name: 'EveApp::SolarSystem'

  scope :nspace, -> { where('id BETWEEN 10000000 AND 10999999') }
  scope :wspace, -> { where('id BETWEEN 11000000 AND 11999999') }
end
