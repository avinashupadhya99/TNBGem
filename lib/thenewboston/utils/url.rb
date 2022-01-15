# frozen_string_literal: false

require "uri"

module Thenewboston
  # Utility functions
  module Util
    # Functions for url formatting
    module URL
      def self.format_url(url)
        raise "URL must a valid url in the format http://[subdomain].domain.com" unless valid_url?(url)

        uri = URI(url)
        protocol = uri.scheme
        protocol ||= "http"
        "#{protocol}://#{uri.host}"
      end

      def self.valid_url?(url)
        !!url[%r/(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/x] # rubocop:disable Layout/LineLength
      end
    end
  end
end
