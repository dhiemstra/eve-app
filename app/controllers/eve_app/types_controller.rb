class EveApp::TypesController < EveApp::SimpleResourceController
  self.includes = %w(group category)
end
