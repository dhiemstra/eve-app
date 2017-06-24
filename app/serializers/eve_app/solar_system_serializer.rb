class EveApp::SolarSystemSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :security do
    object.security.round(2)
  end
  attribute :regionName do
    object.region.try(:name)
  end

  link(:self) { eve_solar_system_path(object) }
end
