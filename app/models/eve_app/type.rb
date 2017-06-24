class EveApp::Type < ApplicationRecord
  belongs_to :group, class_name: 'EveApp::Group'
end
