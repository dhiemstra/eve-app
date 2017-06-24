class EveApp::Category < EveApp::ApplicationRecord
  has_many :types

  scope :published, -> { where(published: true) }
end
