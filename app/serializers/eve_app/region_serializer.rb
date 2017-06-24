class EveApp::RegionSerializer < EveApp::ApplicationSerializer
  attributes :id, :name

  # link(:self) { region_path(object) }
end
