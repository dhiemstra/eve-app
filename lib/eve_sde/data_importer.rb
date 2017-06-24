module EveSDE
  class DataImporter < SSHKit::Backend::Local
    def initialize
      super
      execute :mkdir, '-p', EveSDE.config.tmp_path
    end

    def download
      within EveSDE.config.tmp_path do
        execute :wget, '-q', download_uri + '{,.md5}'
        verify!
        execute :bunzip2, EveSDE.config.archive
      end
    end

    def restore

    end

    private

    def table_list
      @_table_list ||= begin
        tables = EveSDE.table_list.map(&:underscore)
        whitelist = Array[EveSDE.config.table_whitelist].flatten.compact.map(&:to_s)
        whitelist.any? ? tables & whitelist : tables
      end
    end

    def local_archive
      @_local_archive ||= [EveSDE.config.tmp_path, EveSDE.config.archive].join('/')
    end

    def download_uri
      @_download_url ||= begin
        uri = URI(EveSDE.config.download_host)
        uri.path = [uri.path, EveSDE.config.archive].join('/')
        uri.to_s
      end
    end

    def verify!
      md5 = capture :md5, '-q', local_archive
      md5_file = download_uri + '.md5'
      if md5 == open(md5_filename).read.split(' ').first
        execute :rm, '-f', md5_file
      else
        raise "Downloaded data dump is invalid (MD5 hash verification failed)"
      end
    end
  end
end
