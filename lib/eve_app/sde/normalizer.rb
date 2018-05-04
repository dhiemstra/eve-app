module EveApp
  module SDE
    module Normalizer
      def normalize
        normalize_table_names
        primary_keys
        column_names
        missing_relations
        indexes
      end

      def normalize_table_names
        table_names.each do |table_name, normalized_name|
          sql %Q(ALTER TABLE IF EXISTS "#{table_name}" RENAME TO "#{normalized_name}")
        end
      end

      def primary_keys
        tables = table_list.select { |_, info| !!info[:add_primary] }
        tables.values.each do |info|
          sql %Q(ALTER TABLE #{info[:name]} ADD id SERIAL PRIMARY KEY)
        end
      end

      def column_names
        columns.each do |row|
          resource_name = row[:table_name].singularize.gsub('eve_', '')
          row[:target_column_name] = row[:column_name].underscore
          if row[:target_column_name].starts_with?(resource_name)
            row[:target_column_name] = row[:target_column_name].gsub("#{resource_name}_", "")
          end
          if row[:target_column_name] == 'id' && table_info(row[:table_name]).add_primary
            next
          end
          if row[:column_name] != row[:target_column_name]
            sql %Q(ALTER TABLE "#{row[:table_name]}" RENAME COLUMN "#{row[:column_name]}" TO "#{row[:target_column_name]}")
          end
        end
      end

      def indexes
        columns.each do |row|
          if (row[:column_name].ends_with?('id') || row[:column_name] == 'name') && !has_index?(db, row[:table_name], row[:column_name])
            sql %Q(CREATE INDEX IF NOT EXISTS idx_#{row[:table_name]}_#{row[:column_name]} ON #{row[:table_name]} (#{row[:column_name]});)
          end
          if row[:column_name] == 'id'
            sql %Q(ALTER TABLE #{row[:table_name]} DROP CONSTRAINT IF EXISTS #{row[:table_name]}_pkey)
            sql %Q(ALTER TABLE #{row[:table_name]} ADD PRIMARY KEY (id))
          end
        end

        # Custom indexes
        # sql %Q(CREATE INDEX IF NOT EXISTS idx_type_attributes_type_id_attribute_id ON type_attributes (type_id, attribute_id);)
      end

      def missing_relations
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS category_id integer)
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS category_name character varying)
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS group_name character varying)
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS market_group_name character varying)
        sql %Q(ALTER TABLE #{table_names['invMarketGroups']} ADD IF NOT EXISTS root_group_id INTEGER DEFAULT NULL)
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS market_group_root_id integer)
        sql %Q(ALTER TABLE #{table_names['invTypes']} ADD IF NOT EXISTS blueprint_type_id integer)
        sql %Q(UPDATE #{table_names['invTypes']} SET group_name = (SELECT name FROM #{table_names['invGroups']} WHERE id = #{table_names['invTypes']}.group_id))
        sql %Q(UPDATE #{table_names['invTypes']} SET category_id = (SELECT category_id FROM #{table_names['invGroups']} WHERE id = #{table_names['invTypes']}.group_id))
        sql %Q(UPDATE #{table_names['invTypes']} SET category_name = (SELECT name FROM #{table_names['invCategories']} WHERE id = #{table_names['invTypes']}.category_id))
        sql %Q(UPDATE #{table_names['invTypes']} SET market_group_name = (SELECT name FROM #{table_names['invMarketGroups']} WHERE id = #{table_names['invTypes']}.market_group_id))
        # sql %Q(UPDATE #{table_names['invTypes']} SET blueprint_type_id = (SELECT type_id FROM #{table_names['industryActivityProducts']} WHERE activity_id = 1 AND product_type_id = #{table_names['invTypes']}.id LIMIT 1))

        sql %Q(
          WITH RECURSIVE mg_roots(id, root_id) AS (
            SELECT mg.id, mg.id AS root_id FROM #{table_names['invMarketGroups']} AS mg WHERE mg.parent_group_id IS NULL
            UNION ALL
              SELECT c.id, p.root_id FROM mg_roots AS p, #{table_names['invMarketGroups']} AS c WHERE c.parent_group_id = p.id
          )
          UPDATE #{table_names['invMarketGroups']} SET root_group_id = mg_roots.root_id FROM (
            SELECT id, root_id FROM mg_roots WHERE root_id != id
          ) AS mg_roots WHERE #{table_names['invMarketGroups']}.id = mg_roots.id;
        )
        sql %Q(UPDATE #{table_names['invTypes']} SET market_group_root_id = (SELECT root_group_id FROM #{table_names['invMarketGroups']} WHERE id = #{table_names['invTypes']}.market_group_id))
      end

      private

      def columns
        query = %Q(
          SELECT table_name, column_name, ordinal_position
          FROM information_schema.columns
          WHERE
            table_catalog = '#{db_config[:database]}' AND
            table_schema = 'public' AND
            table_name IN(#{table_names.values.map { |n| "'#{n}'" }.join(', ')})
        )
        db.select_all(query).map(&:symbolize_keys)
      end

      def has_index?(db, table, column)
        count = db.select_value %Q(
          select
            COUNT(*)
          from
            pg_class t,
            pg_class i,
            pg_index ix,
            pg_attribute a
          where
            t.oid = ix.indrelid
            and i.oid = ix.indexrelid
            and a.attrelid = t.oid
            and a.attnum = ANY(ix.indkey)
            and t.relkind = 'r'
            and t.relname = '#{table}'
            and a.attname = '#{column}';
        )
        count.to_i > 0
      end

      def table_info(table_name)
        OpenStruct.new(table_list.detect { |(name,info)| [name, info[:name]].include?(table_name) }[1])
      end
    end
  end
end
