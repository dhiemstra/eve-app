module EveApp
  module SDE
    module Downloader
      def download
        within SDE.config.tmp_path do
          execute :wget, '-q', download_uri + '{,.md5}'
          verify!
          execute :bunzip2, SDE.config.archive
        end
      end

      def restore
        table_list.each do |table_name,normalized_name|
          sql %Q(DROP TABLE IF EXISTS "#{table_name}")
          sql %Q(DROP TABLE IF EXISTS "#{normalized_name}")
        end

        options = ['-x -O']
        options << "-h #{db_config[:host]}" if db_config[:host]
        options << "-U #{db_config[:username]}" if db_config[:username]
        options << "-d #{db_config[:database]}"
        options += table_list.keys.map { |name| "-t #{name}" }
        options << local_archive.gsub('.bz2', '')

        execute :pg_restore, *options
      end

      private

      def local_archive
        @_local_archive ||= [SDE.config.tmp_path, SDE.config.archive].join('/')
      end

      def download_uri
        @_download_url ||= begin
          uri = URI(SDE.config.download_host)
          uri.path = [uri.path, SDE.config.archive].join('/')
          uri.to_s
        end
      end

      def verify!
        md5 = capture :md5, '-q', local_archive
        md5_file = local_archive + '.md5'
        if md5 == open(md5_file).read.split(' ').first
          execute :rm, '-f', md5_file
        else
          raise "Downloaded data dump is invalid (MD5 hash verification failed)"
        end
      end
    end
  end
end
