class EveApp::SolarSystem < EveApp::ApplicationRecord
  belongs_to :region, class_name: 'EveApp::Region'
end
