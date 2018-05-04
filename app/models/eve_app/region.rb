class EveApp::Region < EveApp::ApplicationRecord
  has_many :solar_systems
  has_many :constellations

  scope :nspace, -> { where(id: 10000000..10999999) }
  scope :wspace, -> { where(id: 11000000..11999999) }

end
