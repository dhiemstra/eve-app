class EveApp::Type < EveApp::ApplicationRecord
  belongs_to :category
  belongs_to :group
  belongs_to :market_group
  belongs_to :market_group_root, class_name: 'EveApp::MarketGroup'

  has_many :activity_products

  scope :published, -> { where(published: true) }

  def blueprint?
    category_id == EveApp::Category::BLUEPRINT
  end

  def accessoire?
    category_id == EveApp::Category::ACCESSOIRE
  end

  def ship?
    category_id == EveApp::Category::SHIP
  end

  def image(size=64)
    "https://image.eveonline.com/Type/#{id}_#{size}.png"
  end

  def description
    category.name
  end

  def sort_key
    @_sort_key ||= [sort_index, name].join('-')
  end

  private

  def sort_index
    case category_id
    when EveApp::Category::SHIP
      return 1000
    when EveApp::Category::MODULE
      case market_group_root_id
      when EveApp::MarketGroup::SHIP_MODIFICATIONS
        return 1500
      else
        return 1100
      end
    when EveApp::Category::CHARGE
      case market_group_id
      when EveApp::MarketGroup::NANITE_PASTE
        return 1300
      else
        return 1200
      end
    when EveApp::Category::DRONE then 1500
    else 2000
    end
  end
end
