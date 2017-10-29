class EveApp::ActivityMaterial < EveApp::ApplicationRecord
  include EveApp::ActivityRelation

  belongs_to :material_type, class_name: 'EveApp::Type', foreign_key: :material_type_id

  scope :buildable, -> { joins(:material_type).where.not(eve_types: { blueprint_type_id: nil }) }
  scope :simple, -> { joins(:material_type).where(eve_types: { blueprint_type_id: nil }) }
  # scope :order_by_quantity, -> { order(quantity: :desc) }

  def quantity_for(runs)
    runs > 0 ? runs * quantity : 0
  end
end
