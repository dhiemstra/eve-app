class EveApp::ActivityProduct < EveApp::ApplicationRecord
  include EveApp::ActivityRelation

  belongs_to :activity_product, class_name: 'EveApp::Type', foreign_key: :product_type_id

  scope :invention, -> { where(activity_id: EveApp::Activity::INVENTION) }
  scope :manufacture, -> { where(activity_id: EveApp::Activity::MANUFACTURE) }
end
