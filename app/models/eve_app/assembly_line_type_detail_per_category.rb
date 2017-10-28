class EveApp::AssemblyLineTypeDetailPerCategory < EveApp::ApplicationRecord
  belongs_to :assembly_line_type
  belongs_to :category

  scope :standup, -> { where(assembly_line_type_id: EveApp::AssemblyLineType::STANDUP) }
end
