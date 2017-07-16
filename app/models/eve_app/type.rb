class EveApp::Type < EveApp::ApplicationRecord
  belongs_to :category
  belongs_to :group
  belongs_to :market_group

  scope :published, -> { where(published: true) }

  def blueprint?
    category_id == Category::BLUEPRINT
  end

  def accessoire?
    category_id == Category::ACCESSOIRE
  end

  def ship?
    category_id == Category::SHIP
  end

  def image(size=64)
    "https://image.eveonline.com/Type/#{id}_#{size}.png"
  end

  def description
    blueprint? ? blueprint_type + ' blueprint' : category_name
  end

  def sort_key
    @_sort_key ||= [sort_index, name].join('-')
  end

  private

  def sort_index
    case category_id
    when Category::SHIP
      return 1000
    when Category::MODULE
      case market_group.root_group_id
      when MarketGroup::SHIP_MODIFICATIONS
        return 1500
      else
        return 1100
      end
    when Category::CHARGE
      case market_group_id
      when MarketGroup::NANITE_PASTE
        return 1300
      else
        return 1200
      end
    when Category::DRONE then 1500
    else 2000
    end
  end
end
