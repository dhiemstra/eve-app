EveApp::Engine.routes.draw do
  resources :types, only: %i(index show)
  resources :solar_systems, only: %i(index show), path: 'solar-systems'
  resources :regions, only: %i(index show)
end
