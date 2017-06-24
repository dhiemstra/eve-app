class EveApp::RegionSerializer < ActiveModel::Serializer
  attributes :id, :name

  link(:self) { eve_region_path(object) }
end
