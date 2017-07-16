module EveApp
  module SDE
    module Normalizer
      def normalize
        table_names
        column_names
        missing_relations
        indexes
      end

      def table_names
        table_list.each do |table_name, normalized_name|
          sql %Q(ALTER TABLE IF EXISTS "#{table_name}" RENAME TO "#{normalized_name}")
        end
      end

      def column_names
        columns.each do |row|
          resource_name = row[:table_name].singularize.gsub('eve_', '')
          row[:target_column_name] = row[:column_name].underscore
          if row[:target_column_name].starts_with?(resource_name)
            row[:target_column_name] = row[:target_column_name].gsub("#{resource_name}_", "")
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
      end

      def missing_relations
        sql %Q(ALTER TABLE #{table_list['invTypes']} ADD IF NOT EXISTS category_id integer)
        sql %Q(UPDATE #{table_list['invTypes']} SET category_id = (SELECT category_id FROM #{table_list['invGroups']} WHERE id = #{table_list['invTypes']}.group_id))
      end

      def utilities
        sql %Q(ALTER TABLE #{table_list['invMarketGroups']} ADD root_group_id INTEGER DEFAULT NULL)
        sql %Q(
        WITH RECURSIVE mg_roots(id, root_id) AS (
            SELECT mg.id, mg.id AS root_id FROM #{table_list['invMarketGroups']} AS mg WHERE mg.parent_group_id IS NULL
            UNION ALL
              SELECT c.id, p.root_id FROM mg_roots AS p, #{table_list['invMarketGroups']} AS c WHERE c.parent_group_id = p.id
          )
          UPDATE #{table_list['invMarketGroups']} SET root_group_id = mg_roots.root_id FROM (
            SELECT id, root_id FROM mg_roots WHERE root_id != id
          ) AS mg_roots WHERE market_groups.id = mg_roots.id;
        )
        sql %Q(ALTER TABLE #{table_list['invTypes']} ADD category_id integer)
        sql %Q(ALTER TABLE #{table_list['invTypes']} ADD category_name character varying)
        sql %Q(ALTER TABLE #{table_list['invTypes']} ADD market_group_name character varying)
        sql %Q(ALTER TABLE #{table_list['invTypes']} ADD market_group_root_id integer)
        sql %Q(UPDATE #{table_list['invTypes']} SET market_group_root_id = (SELECT root_group_id FROM market_groups WHERE id = #{table_list['invMarketGroups']}.market_group_id))
        sql %Q(UPDATE #{table_list['invTypes']} SET category_id = (SELECT category_id FROM groups WHERE id = #{table_list['invTypes']}.group_id))
        sql %Q(UPDATE #{table_list['invTypes']} SET category_name = (SELECT name FROM categories WHERE id = #{table_list['invTypes']}.category_id))
        sql %Q(UPDATE #{table_list['invTypes']} SET market_group_name = (SELECT name FROM market_groups WHERE id = #{table_list['invTypes']}.market_group_id))
        sql %Q(UPDATE #{table_list['invTypes']} SET market_group_root_id = (SELECT root_group_id FROM market_groups WHERE id = #{table_list['invTypes']}.market_group_id))
      end

      private

      def columns
        query = %Q(
          SELECT table_name, column_name, ordinal_position
          FROM information_schema.columns
          WHERE
            table_catalog = '#{db_config[:database]}' AND
            table_schema = 'public' AND
            table_name IN(#{table_list.values.map { |n| "'#{n}'" }.join(', ')})
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
    end
  end
end
