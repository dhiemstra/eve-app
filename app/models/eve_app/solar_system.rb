class EveApp::SolarSystem < ApplicationRecord
  belongs_to :region, class_name: 'EveApp::Region'
end
