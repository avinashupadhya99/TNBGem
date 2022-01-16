# frozen_string_literal: true

require "uri"
require "net/http"
require "json"

module Thenewboston
  # Internal class for all server nodes
  class ServerNode
    attr_reader :url, :options

    def initialize(url, options = {})
      @url = Thenewboston::Util::URL.format_url(url)
      @options = Thenewboston::Util::Options.format_default_options(options)
    end

    def get_data(endpoint, params = {})
      uri = URI("#{@url}#{endpoint}")
      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get_response(uri)
      JSON.parse(res.body) if res.is_a?(Net::HTTPSuccess)
    end

    def get_paginated_data(endpoint, options)
      self.get_data(endpoint, {
          **@options[:defaultPagination],
          **options
      })    
    end
  end
end
