require "pathname"
require "eve_app/engine"

module EveApp
  autoload :EveCentral, 'eve_app/eve_central'
  autoload :ItemParser, 'eve_app/item_parser'
  autoload :SDE,        'eve_app/sde'
  autoload :XmlApi,     'eve_app/xml_api'

  class << self
    def root
      @root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end

    def table_name_prefix
      @_table_name_prefix ||= begin
        prefix = EveApp::SDE.config.table_prefix.presence
        prefix ? "#{prefix}_" : super
      end
    end
  end
end
