require 'eve_app'

namespace :eve_app do
  namespace :sde do
    desc "Download latest postgresql datadump"
    task :download do
      di = EveApp::SDE::DataImporter.new
      di.download
    end
  end
end
