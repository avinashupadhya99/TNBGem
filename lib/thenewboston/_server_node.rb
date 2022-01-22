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
      get_data endpoint,
               {
                 **@options[:defaultPagination],
                 **options
               }
    end

    def patch_data(endpoint, data)
      uri = URI("#{@url}#{endpoint}")
      request = Net::HTTP::Patch.new(uri)
      request.content_type = "application/json"
      request.body = JSON.dump(data)
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
      JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end
  end
end
