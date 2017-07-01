module EveApp
  module XmlApi
    autoload :Calls,   'eve_app/xml_api/calls'
    autoload :Classes, 'eve_app/xml_api/classes'
    autoload :Client,  'eve_app/xml_api/client'

    class ApiError < StandardError; end
    class ConnectionError < ApiError; end
  end
end
