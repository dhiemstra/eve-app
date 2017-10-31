class EveApp::Type < EveApp::ApplicationRecord
  belongs_to :category
  belongs_to :group
  belongs_to :market_group
  belongs_to :market_group_root, class_name: 'EveApp::MarketGroup'
  belongs_to :blueprint_type, class_name: 'EveApp::Type', optional: true

  has_one :manufacture_product, -> { manufacture }, class_name: 'EveApp::ActivityProduct'
  has_one :manufacture_product_type, through: :manufacture_product, source: :product_type

  has_many :activity_materials

  scope :published, -> { where(published: true) }

  def kind
    case group_id
    when *EveApp::Group::COMPONENTS     then :component
    when *EveApp::Group::SUPER_CAPITALS then :supercapital
    when *EveApp::Group::CAPITALS       then :capital
    else category_name.downcase.gsub(' ', '_').to_sym
    end
  end

  def blueprint?
    category_id == EveApp::Category::BLUEPRINT
  end

  def accessoire?
    category_id == EveApp::Category::ACCESSOIRE
  end

  def ship?
    category_id == EveApp::Category::SHIP
  end

  def capital?
    EveApp::Group::CAPITALS.include?(group_id)
  end

  def supercapital?
    EveApp::Group::SUPER_CAPITALS.include?(group_id)
  end

  def component?
    EveApp::Group::COMPONENTS.include?(group_id)
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
    when EveApp::Category::ASTEROID, EveApp::Category::MATERIAL
      [market_group_name, base_price].join('-')
    when EveApp::Category::SHIP
      1000
    when EveApp::Category::MODULE
      case market_group_root_id
      when EveApp::MarketGroup::SHIP_MODIFICATIONS
        1500
      else
        1100
      end
    when EveApp::Category::CHARGE
      case market_group_id
      when EveApp::MarketGroup::NANITE_PASTE
        1300
      else
        1200
      end
    when EveApp::Category::DRONE then 1500
    else 2000
    end
  end
end
