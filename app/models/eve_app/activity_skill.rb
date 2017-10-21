class EveApp::ActivitySkill < EveApp::ApplicationRecord
  include EveApp::ActivityRelation

  belongs_to :skill, class_name: 'EveApp::Type', foreign_key: :skill_id
end
