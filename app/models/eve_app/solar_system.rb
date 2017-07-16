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

  has_many :stations
end
