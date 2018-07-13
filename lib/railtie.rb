require "active_support/core_ext/string/inflections"

module PlugEventAPIMiddlewares
  VERSION = "1.1.0"

  class << self
    def application_name
      Rails.application.class.name.split('::').first.underscore
    end

    def application_version
      "#{application_name.camelize}::VERSION".constantize
    end
  end

  class Railtie < Rails::Railtie
    # Ensure plugin is compatible with Peatio.
    config.before_initialize do
      v = PlugEventAPIMiddlewares.application_version
      unless v.starts_with?("1.7") || v.starts_with?("1.8")
        Kernel.abort "This plugin is designed to work only on #{PlugEventAPIMiddlewares.application_name.camelize} 1.7.x and 1.8.x. You have #{v}."
      end
    end

    config.after_initialize do
      # require_relative "event_api/middlewares/plug/generate_jwt"
      require_relative "event_api/middlewares/plug/publish_to_rabbitmq"
      EventAPI.middlewares = [
        EventAPI::Middlewares::IncludeEventMetadata.new,
        # EventAPI::Middlewares::Plug::GenerateJWT.new,
        EventAPI::Middlewares::PrintToScreen.new,
        EventAPI::Middlewares::Plug::PublishToRabbitMQ.new
      ]
    end
  end
end
