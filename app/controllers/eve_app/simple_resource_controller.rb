require_dependency "eve_app/application_controller"

module EveApp
  class SimpleResourceController < EveApp::ApplicationController
    class_attribute :allow_index
    class_attribute :includes
    class_attribute :serializer_includes
    # before_action :authenticate_token!

    def index
      if params[:filter] && params[:filter][:id]
        render json: scope.where(id: params[:filter][:id].split(',')), include: serializer_include
      elsif self.allow_index
        render json: scope, include: self.serializer_include
      else
        render :bad_request
      end
    end

    def show
      render json: scope.find(params[:id]) #, include: self.serializer_include
    end

    protected

    def model_name
      self.class.to_s.gsub(/(.+?)Controller/, '\1').singularize.constantize
    end

    def scope
      model_name.includes(self.includes).page(params[:page])
    end

    def serializer_include
      self.serializer_includes || ['*']
    end
  end
end
