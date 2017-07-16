require "pathname"
require "active_model_serializers"
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

if defined?(::Rails)
  module ::Rails
    class Application
      rake_tasks do
        Dir[File.join(EveApp.root, "/lib/tasks/", "**/*.rake")].each do |file|
          load file
        end
      end
    end
  end
end
