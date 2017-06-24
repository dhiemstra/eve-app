class EveApp::Group < ApplicationRecord
  has_many :types, class_name: 'EveApp::Type'
end
