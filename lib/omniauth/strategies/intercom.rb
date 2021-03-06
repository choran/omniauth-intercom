require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Intercom < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "intercom"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => 'https://api.intercom.io',
        # :site => 'http://localhost:4000',
        :authorize_url => 'https://app.intercom.io/oauth',
        :token_url => 'https://api.intercom.io/auth/eagle/token'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        accept_headers
        access_token.options[:mode] = :body
        @raw_info ||= access_token.get('/me').parsed
      end

      def request_phase
        authorize_url
        super
      end

      protected

      def authorize_url
        options.client_options[:authorize_url] += '/signup' if request.params.fetch('signup', false)
      end

      def accept_headers
        access_token.client.connection.headers['Authorization'] = access_token.client.connection.basic_auth(access_token.token, '')
        access_token.client.connection.headers['Accept'] = "application/vnd.intercom.3+json"
      end

    end
  end
end
