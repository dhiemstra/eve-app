class EveApp::Group < EveApp::ApplicationRecord
  has_many :types, class_name: 'EveApp::Type'
  has_many :assembly_line_details, -> { standup }, class_name: 'EveApp::AssemblyLineTypeDetailPerGroup'
  has_many :assembly_line_types, through: :assembly_line_details
end
