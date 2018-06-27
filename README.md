
The middlewares shipped in this repository solve two problems:

1) Generation of JWT.

2) Publishing message to RabbitMQ.

## Configuration

Include the following in `config/application.yml` at Peatio:

```yml
# JWT configuration.
# You can generate keypair using:
#
#   ruby -e "require 'openssl'; require 'base64'; OpenSSL::PKey::RSA.generate(2048).tap { |p| puts '', 'PRIVATE RSA KEY (URL-safe Base64 encoded, PEM):', '', Base64.urlsafe_encode64(p.to_pem), '', 'PUBLIC RSA KEY (URL-safe Base64 encoded, PEM):', '', Base64.urlsafe_encode64(p.public_key.to_pem) }"
#
EVENT_API_JWT_PRIVATE_KEY: ~ # Private key. Must be URL-safe Base64 encoded in PEM format.
EVENT_API_JWT_ALGORITHM:   RS256

# RabbitMQ configuration.
# You can use just «EVENT_API_RABBITMQ_URL» or specify configuration per separate variable.
EVENT_API_RABBITMQ_URL: ~
EVENT_API_RABBITMQ_HOST:     localhost
EVENT_API_RABBITMQ_PORT:     "5672"
EVENT_API_RABBITMQ_USERNAME: guest
EVENT_API_RABBITMQ_PASSWORD: guest
```
