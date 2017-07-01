class EveApp::Station < EveApp::ApplicationRecord
  belongs_to :solar_system
  belongs_to :region

  has_many :stations

  scope :active, -> { where(deleted: false) }
  scope :structure, -> { where('id > ?', 100000000) }
end
