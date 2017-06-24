class EveApp::MarketGroup < EveApp::ApplicationRecord
  belongs_to :parent, class_name: 'MarketGroup', foreign_key: 'parent_group_id'

  has_many :types

  def root
    obj = self
    while !obj.parent.nil?
      obj = obj.parent
    end
    obj
  end
end
