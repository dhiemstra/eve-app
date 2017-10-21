class EveApp::Activity < EveApp::ApplicationRecord
  TYPE_MAP = {
    1: :manufacture,
    3: :research_te,
    4: :research_me,
    5: :copying,
    8: :invention
  }
  MANUFACTURE = 1
  RESEARCH_TE = 3
  RESEARCH_ME = 4
  COPYING = 5
  INVENTION = 8

  has_many :industry_activities

  def icon
    case id
    when 1 then 'manufacturing.png'
    when 3 then 'researchTime.png'
    when 4 then 'researchMaterial.png'
    when 5 then 'copying.png'
    when 8 then 'invention.png'
    end
  end
end
