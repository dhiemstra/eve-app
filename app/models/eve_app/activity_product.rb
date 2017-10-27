class EveApp::ActivityProduct < EveApp::ApplicationRecord
  belongs_to :type
  belongs_to :product_type, class_name: 'EveApp::Type', foreign_key: :product_type_id

  EveApp::Activity::TYPE_MAP.each do |id, type|
    scope type, -> { where(activity_id: id) }
  end
end
