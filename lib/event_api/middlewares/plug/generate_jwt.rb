require "base64"
require "openssl"
require "securerandom"

module EventAPI
  module Middlewares
    module Plug
      class GenerateJWT
        def call(event_name, event_payload)
          jwt_payload = {
            iss:   PlugEventAPIMiddlewares.application_name,
            jti:   SecureRandom.uuid,
            iat:   Time.now.to_i,
            exp:   Time.now.to_i + 60,
            event: event_payload
          }

          private_key = OpenSSL::PKey.read(Base64.urlsafe_decode64(ENV.fetch("EVENT_API_JWT_PRIVATE_KEY")))
          algorithm   = ENV.fetch("EVENT_API_JWT_ALGORITHM")
          jwt         = JWT::Multisig.generate_jwt jwt_payload, \
                                                   { PlugEventAPIMiddlewares.application_name.to_sym => private_key },
                                                   { PlugEventAPIMiddlewares.application_name.to_sym => algorithm }

          [event_name, jwt]
        end
      end
    end
  end
end
