class EveApp::Group < EveApp::ApplicationRecord
  has_many :types, class_name: 'EveApp::Type'
end
