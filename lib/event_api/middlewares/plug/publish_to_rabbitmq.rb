module EventAPI
  module Middlewares
    module Plug
      class PublishToRabbitMQ
        extend Memoist

        def call(event_name, event_payload)
          Rails.logger.debug do
            "\nPublishing #{routing_key(event_name)} (routing key) to #{exchange_name(event_name)} (exchange name).\n"
          end
          exchange = bunny_exchange(exchange_name(event_name))
          exchange.publish(event_payload.to_json, routing_key: routing_key(event_name))
          [event_name, event_payload]
        end

      private

        def bunny_session
          Bunny::Session.new(rabbitmq_credentials).tap do |session|
            session.start
            Kernel.at_exit { session.stop }
          end
        end
        memoize :bunny_session

        def bunny_channel
          bunny_session.channel
        end
        memoize :bunny_channel

        def bunny_exchange(name)
          bunny_channel.direct(name)
        end
        memoize :bunny_exchange

        def rabbitmq_credentials
          { host:     ENV.fetch("RABBITMQ_HOST"),
            port:     ENV.fetch("RABBITMQ_PORT"),
            username: ENV.fetch("RABBITMQ_USERNAME"),
            password: ENV.fetch("RABBITMQ_PASSWORD") }
        end

        def exchange_name(event_name)
          "#{PlugEventAPIMiddlewares.application_name}.events.#{event_name.split('.').first}"
        end

        def routing_key(event_name)
          event_name.split('.').drop(1).join('.')
        end
      end
    end
  end
end
