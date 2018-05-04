class EveApp::SolarSystemJump < EveApp::ApplicationRecord
  belongs_to :from_region, class_name: 'EveApp::Region', foreign_key: :from_region_id
  belongs_to :from_solar_system, class_name: 'EveApp::SolarSystem', foreign_key: :from_solar_system_id
  belongs_to :to_region, class_name: 'EveApp::Region', foreign_key: :to_region_id
  belongs_to :to_solar_system, class_name: 'EveApp::SolarSystem', foreign_key: :to_solar_system_id

  scope :unique, -> {
    select('
      DISTINCT
      (CASE WHEN from_solar_system_id < to_solar_system_id THEN from_solar_system_id ELSE to_solar_system_id END) AS from_solar_system_id,
      (CASE WHEN from_solar_system_id > to_solar_system_id THEN from_solar_system_id ELSE to_solar_system_id END) AS to_solar_system_id,
      from_region_id, to_region_id, from_constellation_id, to_constellation_id
    ').order('from_solar_system_id, to_solar_system_id')
  }
end
