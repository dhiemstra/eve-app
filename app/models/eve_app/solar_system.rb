class EveApp::SolarSystem < EveApp::ApplicationRecord
  JITA = 30000142
  PERIMITER = 30000144
  NEW_CALDARI = 30000145
  AMARR = 30002187
  NIYABAINEN = 30000143
  P3EN = 30000250
  ASHAB = 30003491
  MAURASI = 30000140

  belongs_to :region
  belongs_to :constellation

  has_many :jumps, class_name: 'SolarSystemJump', foreign_key: :from_solar_system_id
  has_many :stations

  scope :nspace, -> { where(id: 30000000..30999999) }
  scope :wspace, -> { where(id: 31000000..31999999) }

  def security_category
    case security.round(1)
    when (0.5..1.0)  then :high
    when (0.0..0.4)  then :low
    when (-1.0..0.0) then :null
    end
  end
end
