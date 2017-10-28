class EveApp::AssemblyLineType < EveApp::ApplicationRecord
  STANDUP = %w{ 175 176 177 178 179 180 181 182 183 184 }

  belongs_to :activity

  scope :standup, -> { where(id: STANDUP) }
end
