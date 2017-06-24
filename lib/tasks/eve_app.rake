require 'eve_app'

namespace :eve_app do
  namespace :sde do
    importer = EveApp::SDE::DataImporter.new

    desc "Download latest postgresql datadump"
    task :download do
      importer.download
    end

    desc "Import and normalize EVE database"
    task import: :environment do
      importer.restore
      importer.normalize
    end

    desc "Import raw data into the database"
    task restore: :environment do
      importer.restore
    end

    desc "Import raw data into the database"
    task normalize: :environment do
      importer.normalize
    end
  end
end
