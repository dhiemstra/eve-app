require "pathname"

module EveApp
  autoload :Engine,  'eve_app/engine'
  autoload :Version, 'eve_app/version'
  autoload :SDE,     'eve_app/sde'

  class << self
    def root
      @root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end

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
