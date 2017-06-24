class EveApp::TypeSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :group do
    object.group.try(:name)
  end

  link(:self) { eve_type_path(object) }
end
