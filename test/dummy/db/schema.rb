ActiveRecord::Schema.define(version: 20180504102441) do
  create_table "eve_activities", id: :serial, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "activityID", null: false
    t.integer "time"
    t.index ["type_id"], name: "idx_activities_type_id"
  end

  create_table "eve_activity_materials", id: :serial, force: :cascade do |t|
    t.integer "type_id"
    t.integer "activity_id"
    t.integer "material_type_id"
    t.integer "quantity"
    t.index ["activity_id"], name: "idx_activity_materials_activity_id"
    t.index ["material_type_id"], name: "idx_activity_materials_material_type_id"
    t.index ["type_id"], name: "idx_activity_materials_type_id"
  end

  create_table "eve_activity_probabilities", id: false, force: :cascade do |t|
    t.integer "type_id"
    t.integer "activity_id"
    t.integer "product_type_id"
    t.decimal "probability", precision: 3, scale: 2
    t.index ["activity_id"], name: "idx_activity_probabilities_activity_id"
    t.index ["product_type_id"], name: "idx_activity_probabilities_product_type_id"
    t.index ["type_id"], name: "idx_activity_probabilities_type_id"
  end

  create_table "eve_activity_products", id: false, force: :cascade do |t|
    t.integer "type_id"
    t.integer "activity_id"
    t.integer "product_type_id"
    t.integer "quantity"
    t.index ["activity_id"], name: "idx_activity_products_activity_id"
    t.index ["product_type_id"], name: "idx_activity_products_product_type_id"
    t.index ["type_id"], name: "idx_activity_products_type_id"
  end

  create_table "eve_activity_skills", id: false, force: :cascade do |t|
    t.integer "type_id"
    t.integer "activity_id"
    t.integer "skill_id"
    t.integer "level"
    t.index ["activity_id"], name: "idx_activity_skills_activity_id"
    t.index ["skill_id"], name: "idx_activity_skills_skill_id"
    t.index ["type_id"], name: "idx_activity_skills_type_id"
  end

  create_table "eve_assembly_line_type_detail_per_categories", id: false, force: :cascade do |t|
    t.integer "assembly_line_type_id", null: false
    t.integer "category_id", null: false
    t.float "time_multiplier"
    t.float "material_multiplier"
    t.float "cost_multiplier"
    t.index ["assembly_line_type_id"], name: "idx_assembly_line_type_detail_per_categories_assembly_line_"
    t.index ["category_id"], name: "idx_assembly_line_type_detail_per_categories_category_id"
  end

  create_table "eve_assembly_line_type_detail_per_groups", id: false, force: :cascade do |t|
    t.integer "assembly_line_type_id", null: false
    t.integer "group_id", null: false
    t.float "time_multiplier"
    t.float "material_multiplier"
    t.float "cost_multiplier"
    t.index ["assembly_line_type_id"], name: "idx_assembly_line_type_detail_per_groups_assembly_line_type"
    t.index ["group_id"], name: "idx_assembly_line_type_detail_per_groups_group_id"
  end

  create_table "eve_assembly_line_types", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "description", limit: 1000
    t.float "base_time_multiplier"
    t.float "base_material_multiplier"
    t.float "base_cost_multiplier"
    t.float "volume"
    t.integer "activity_id"
    t.float "min_cost_per_hour"
    t.index ["activity_id"], name: "idx_assembly_line_types_activity_id"
    t.index ["id"], name: "idx_assembly_line_types_id"
    t.index ["name"], name: "idx_assembly_line_types_name"
  end

  create_table "eve_attribute_categories", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "category_name", limit: 50
    t.string "category_description", limit: 200
    t.index ["category_id"], name: "idx_attribute_categories_category_id"
  end

  create_table "eve_attribute_types", id: false, force: :cascade do |t|
    t.integer "attribute_id", null: false
    t.string "attribute_name", limit: 100
    t.string "description", limit: 1000
    t.integer "icon_id"
    t.float "default_value"
    t.boolean "published"
    t.string "display_name", limit: 150
    t.integer "unit_id"
    t.boolean "stackable"
    t.boolean "high_is_good"
    t.integer "category_id"
    t.index ["attribute_id"], name: "idx_attribute_types_attribute_id"
    t.index ["category_id"], name: "idx_attribute_types_category_id"
    t.index ["icon_id"], name: "idx_attribute_types_icon_id"
    t.index ["unit_id"], name: "idx_attribute_types_unit_id"
  end

  create_table "eve_blueprints", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "max_production_limit"
    t.index ["type_id"], name: "idx_blueprints_type_id"
  end

  create_table "eve_categories", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.integer "icon_id"
    t.boolean "published"
    t.index ["icon_id"], name: "idx_categories_icon_id"
    t.index ["id"], name: "idx_categories_id"
    t.index ["name"], name: "idx_categories_name"
  end

  create_table "eve_constellations", id: :integer, default: nil, force: :cascade do |t|
    t.integer "region_id"
    t.string "name", limit: 100
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "x_min"
    t.float "x_max"
    t.float "y_min"
    t.float "y_max"
    t.float "z_min"
    t.float "z_max"
    t.integer "faction_id"
    t.float "radius"
    t.index ["faction_id"], name: "idx_constellations_faction_id"
    t.index ["id"], name: "idx_constellations_id"
    t.index ["name"], name: "idx_constellations_name"
    t.index ["region_id"], name: "idx_constellations_region_id"
  end

  create_table "eve_denormalizes", id: false, force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "type_id"
    t.integer "group_id"
    t.integer "solar_system_id"
    t.integer "constellation_id"
    t.integer "region_id"
    t.integer "orbit_id"
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "radius"
    t.string "item_name", limit: 100
    t.float "security"
    t.integer "celestial_index"
    t.integer "orbit_index"
    t.index ["constellation_id"], name: "idx_denormalizes_constellation_id"
    t.index ["group_id"], name: "idx_denormalizes_group_id"
    t.index ["item_id"], name: "idx_denormalizes_item_id"
    t.index ["orbit_id"], name: "idx_denormalizes_orbit_id"
    t.index ["region_id"], name: "idx_denormalizes_region_id"
    t.index ["solar_system_id"], name: "idx_denormalizes_solar_system_id"
    t.index ["type_id"], name: "idx_denormalizes_type_id"
  end

  create_table "eve_effects", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 400
    t.integer "category"
    t.integer "pre_expression"
    t.integer "post_expression"
    t.string "description", limit: 1000
    t.string "guid", limit: 60
    t.integer "icon_id"
    t.boolean "is_offensive"
    t.boolean "is_assistance"
    t.integer "duration_attribute_id"
    t.integer "tracking_speed_attribute_id"
    t.integer "discharge_attribute_id"
    t.integer "range_attribute_id"
    t.integer "falloff_attribute_id"
    t.boolean "disallow_auto_repeat"
    t.boolean "published"
    t.string "display_name", limit: 100
    t.boolean "is_warp_safe"
    t.boolean "range_chance"
    t.boolean "electronic_chance"
    t.boolean "propulsion_chance"
    t.integer "distribution"
    t.string "sfx_name", limit: 20
    t.integer "npc_usage_chance_attribute_id"
    t.integer "npc_activation_chance_attribute_id"
    t.integer "fitting_usage_chance_attribute_id"
    t.text "modifier_info"
    t.index ["discharge_attribute_id"], name: "idx_effects_discharge_attribute_id"
    t.index ["duration_attribute_id"], name: "idx_effects_duration_attribute_id"
    t.index ["falloff_attribute_id"], name: "idx_effects_falloff_attribute_id"
    t.index ["fitting_usage_chance_attribute_id"], name: "idx_effects_fitting_usage_chance_attribute_id"
    t.index ["guid"], name: "idx_effects_guid"
    t.index ["icon_id"], name: "idx_effects_icon_id"
    t.index ["id"], name: "idx_effects_id"
    t.index ["name"], name: "idx_effects_name"
    t.index ["npc_activation_chance_attribute_id"], name: "idx_effects_npc_activation_chance_attribute_id"
    t.index ["npc_usage_chance_attribute_id"], name: "idx_effects_npc_usage_chance_attribute_id"
    t.index ["range_attribute_id"], name: "idx_effects_range_attribute_id"
    t.index ["tracking_speed_attribute_id"], name: "idx_effects_tracking_speed_attribute_id"
  end

  create_table "eve_expressions", id: :integer, default: nil, force: :cascade do |t|
    t.integer "operand_id"
    t.integer "arg1"
    t.integer "arg2"
    t.string "value", limit: 100
    t.string "description", limit: 1000
    t.string "name", limit: 500
    t.integer "type_id"
    t.integer "group_id"
    t.integer "attribute_id"
    t.index ["attribute_id"], name: "idx_expressions_attribute_id"
    t.index ["group_id"], name: "idx_expressions_group_id"
    t.index ["id"], name: "idx_expressions_id"
    t.index ["name"], name: "idx_expressions_name"
    t.index ["operand_id"], name: "idx_expressions_operand_id"
    t.index ["type_id"], name: "idx_expressions_type_id"
  end

  create_table "eve_groups", id: :integer, default: nil, force: :cascade do |t|
    t.integer "category_id"
    t.string "name", limit: 100
    t.integer "icon_id"
    t.boolean "use_base_price"
    t.boolean "anchored"
    t.boolean "anchorable"
    t.boolean "fittable_non_singleton"
    t.boolean "published"
    t.index ["category_id"], name: "idx_groups_category_id"
    t.index ["icon_id"], name: "idx_groups_icon_id"
    t.index ["id"], name: "idx_groups_id"
    t.index ["name"], name: "idx_groups_name"
  end

  create_table "eve_jumps", id: false, force: :cascade do |t|
    t.integer "stargate_id", null: false
    t.integer "destination_id"
    t.index ["destination_id"], name: "idx_jumps_destination_id"
    t.index ["stargate_id"], name: "idx_jumps_stargate_id"
  end

  create_table "eve_location_scenes", id: false, force: :cascade do |t|
    t.integer "location_id", null: false
    t.integer "graphic_id"
    t.index ["graphic_id"], name: "idx_location_scenes_graphic_id"
    t.index ["location_id"], name: "idx_location_scenes_location_id"
  end

  create_table "eve_market_groups", id: :integer, default: nil, force: :cascade do |t|
    t.integer "parent_group_id"
    t.string "name", limit: 100
    t.string "description", limit: 3000
    t.integer "icon_id"
    t.boolean "has_types"
    t.integer "root_group_id"
    t.index ["icon_id"], name: "idx_market_groups_icon_id"
    t.index ["id"], name: "idx_market_groups_id"
    t.index ["name"], name: "idx_market_groups_name"
    t.index ["parent_group_id"], name: "idx_market_groups_parent_group_id"
    t.index ["root_group_id"], name: "idx_market_groups_root_group_id"
  end

  create_table "eve_meta_groups", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "description", limit: 1000
    t.integer "icon_id"
    t.index ["icon_id"], name: "idx_meta_groups_icon_id"
    t.index ["id"], name: "idx_meta_groups_id"
    t.index ["name"], name: "idx_meta_groups_name"
  end

  create_table "eve_meta_types", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "parent_type_id"
    t.integer "meta_group_id"
    t.index ["meta_group_id"], name: "idx_meta_types_meta_group_id"
    t.index ["parent_type_id"], name: "idx_meta_types_parent_type_id"
    t.index ["type_id"], name: "idx_meta_types_type_id"
  end

  create_table "eve_region_jumps", id: false, force: :cascade do |t|
    t.integer "from_region_id", null: false
    t.integer "to_region_id", null: false
    t.index ["from_region_id"], name: "idx_region_jumps_from_region_id"
    t.index ["to_region_id"], name: "idx_region_jumps_to_region_id"
  end

  create_table "eve_regions", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "x_min"
    t.float "x_max"
    t.float "y_min"
    t.float "y_max"
    t.float "z_min"
    t.float "z_max"
    t.integer "faction_id"
    t.float "radius"
    t.index ["faction_id"], name: "idx_regions_faction_id"
    t.index ["id"], name: "idx_regions_id"
    t.index ["name"], name: "idx_regions_name"
  end

  create_table "eve_solar_system_jumps", id: false, force: :cascade do |t|
    t.integer "from_region_id"
    t.integer "from_constellation_id"
    t.integer "from_solar_system_id", null: false
    t.integer "to_solar_system_id", null: false
    t.integer "to_constellation_id"
    t.integer "to_region_id"
    t.index ["from_constellation_id"], name: "idx_solar_system_jumps_from_constellation_id"
    t.index ["from_region_id"], name: "idx_solar_system_jumps_from_region_id"
    t.index ["from_solar_system_id"], name: "idx_solar_system_jumps_from_solar_system_id"
    t.index ["to_constellation_id"], name: "idx_solar_system_jumps_to_constellation_id"
    t.index ["to_region_id"], name: "idx_solar_system_jumps_to_region_id"
    t.index ["to_solar_system_id"], name: "idx_solar_system_jumps_to_solar_system_id"
  end

  create_table "eve_solar_systems", id: :integer, default: nil, force: :cascade do |t|
    t.integer "region_id"
    t.integer "constellation_id"
    t.string "name", limit: 100
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "x_min"
    t.float "x_max"
    t.float "y_min"
    t.float "y_max"
    t.float "z_min"
    t.float "z_max"
    t.float "luminosity"
    t.boolean "border"
    t.boolean "fringe"
    t.boolean "corridor"
    t.boolean "hub"
    t.boolean "international"
    t.boolean "regional"
    t.boolean "constellation"
    t.float "security"
    t.integer "faction_id"
    t.float "radius"
    t.integer "sun_type_id"
    t.string "security_class", limit: 2
    t.index ["constellation_id"], name: "idx_solar_systems_constellation_id"
    t.index ["faction_id"], name: "idx_solar_systems_faction_id"
    t.index ["id"], name: "idx_solar_systems_id"
    t.index ["name"], name: "idx_solar_systems_name"
    t.index ["region_id"], name: "idx_solar_systems_region_id"
    t.index ["sun_type_id"], name: "idx_solar_systems_sun_type_id"
  end

  create_table "eve_station_types", id: :integer, default: nil, force: :cascade do |t|
    t.float "dock_entry_x"
    t.float "dock_entry_y"
    t.float "dock_entry_z"
    t.float "dock_orientation_x"
    t.float "dock_orientation_y"
    t.float "dock_orientation_z"
    t.integer "operation_id"
    t.integer "office_slots"
    t.float "reprocessing_efficiency"
    t.boolean "conquerable"
    t.index ["id"], name: "idx_station_types_id"
    t.index ["operation_id"], name: "idx_station_types_operation_id"
  end

  create_table "eve_stations", id: :bigint, default: nil, force: :cascade do |t|
    t.float "security"
    t.float "docking_cost_per_volume"
    t.float "max_ship_volume_dockable"
    t.integer "office_rental_cost"
    t.integer "operation_id"
    t.integer "type_id"
    t.integer "corporation_id"
    t.integer "solar_system_id"
    t.integer "constellation_id"
    t.integer "region_id"
    t.string "name", limit: 100
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "reprocessing_efficiency"
    t.float "reprocessing_stations_take"
    t.integer "reprocessing_hangar_flag"
    t.index ["constellation_id"], name: "idx_stations_constellation_id"
    t.index ["corporation_id"], name: "idx_stations_corporation_id"
    t.index ["id"], name: "idx_stations_id"
    t.index ["name"], name: "idx_stations_name"
    t.index ["operation_id"], name: "idx_stations_operation_id"
    t.index ["region_id"], name: "idx_stations_region_id"
    t.index ["solar_system_id"], name: "idx_stations_solar_system_id"
    t.index ["type_id"], name: "idx_stations_type_id"
  end

  create_table "eve_traits", id: :integer, default: nil, force: :cascade do |t|
    t.integer "type_id"
    t.integer "skill_id"
    t.float "bonus"
    t.text "bonus_text"
    t.integer "unit_id"
    t.index ["id"], name: "idx_traits_id"
    t.index ["skill_id"], name: "idx_traits_skill_id"
    t.index ["type_id"], name: "idx_traits_type_id"
    t.index ["unit_id"], name: "idx_traits_unit_id"
  end

  create_table "eve_type_attributes", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "attribute_id", null: false
    t.integer "value_int"
    t.float "value_float"
    t.index ["attribute_id"], name: "idx_type_attributes_attribute_id"
    t.index ["type_id"], name: "idx_type_attributes_type_id"
  end

  create_table "eve_type_effects", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "effect_id", null: false
    t.boolean "is_default"
    t.index ["effect_id"], name: "idx_type_effects_effect_id"
    t.index ["type_id"], name: "idx_type_effects_type_id"
  end

  create_table "eve_types", id: :integer, default: nil, force: :cascade do |t|
    t.integer "group_id"
    t.string "name", limit: 100
    t.text "description"
    t.float "mass"
    t.float "volume"
    t.float "capacity"
    t.integer "portion_size"
    t.integer "race_id"
    t.decimal "base_price", precision: 19, scale: 4
    t.boolean "published"
    t.integer "market_group_id"
    t.integer "icon_id"
    t.integer "sound_id"
    t.integer "graphic_id"
    t.integer "category_id"
    t.string "category_name"
    t.string "group_name"
    t.string "market_group_name"
    t.integer "market_group_root_id"
    t.integer "blueprint_type_id"
    t.index ["blueprint_type_id"], name: "idx_types_blueprint_type_id"
    t.index ["category_id"], name: "idx_types_category_id"
    t.index ["graphic_id"], name: "idx_types_graphic_id"
    t.index ["group_id"], name: "idx_types_group_id"
    t.index ["icon_id"], name: "idx_types_icon_id"
    t.index ["id"], name: "idx_types_id"
    t.index ["market_group_id"], name: "idx_types_market_group_id"
    t.index ["market_group_root_id"], name: "idx_types_market_group_root_id"
    t.index ["name"], name: "idx_types_name"
    t.index ["race_id"], name: "idx_types_race_id"
    t.index ["sound_id"], name: "idx_types_sound_id"
  end

  create_table "eve_universes", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.float "x"
    t.float "y"
    t.float "z"
    t.float "x_min"
    t.float "x_max"
    t.float "y_min"
    t.float "y_max"
    t.float "z_min"
    t.float "z_max"
    t.float "radius"
    t.index ["id"], name: "idx_universes_id"
    t.index ["name"], name: "idx_universes_name"
  end

  create_table "eve_volumes", id: false, force: :cascade do |t|
    t.integer "type_id", null: false
    t.integer "volume"
    t.index ["type_id"], name: "idx_volumes_type_id"
  end
end
