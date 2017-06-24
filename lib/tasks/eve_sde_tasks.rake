require 'eve-sde'

namespace :sde do
  desc "Download latest postgresql datadump"
  task :download do
    di = EveSDE::DataImporter.new
    di.download
  end
end
