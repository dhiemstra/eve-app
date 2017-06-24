class EveApp::Type < EveApp::ApplicationRecord
  belongs_to :category
  belongs_to :group
  belongs_to :market_group

  scope :published, -> { where(published: true) }
end
