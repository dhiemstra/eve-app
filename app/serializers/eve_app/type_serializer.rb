class EveApp::TypeSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :category do
    object.category.try(:name)
  end
  attribute :group do
    object.group.try(:name)
  end

  # link(:self) { type_path(object) }
end
