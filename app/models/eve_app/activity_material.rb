class EveApp::ActivityMaterial < EveApp::ApplicationRecord
  include EveApp::ActivityRelation

  belongs_to :material_type, class_name: 'EveApp::Type', foreign_key: :material_type_id

  scope :order_by_quantity, -> { order(quantity: :desc) }

  def quantity_for(runs)
    runs > 0 ? runs * quantity : 0
  end
end
