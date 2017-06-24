class EveApp::SolarSystemSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :security do
    object.security.round(2)
  end

  # link(:self) { solar_system_path(object) }
end
