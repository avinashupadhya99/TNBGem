# frozen_string_literal: true

require "uri"
require "net/http"

module Thenewboston
  # Internal class for all server nodes
  class ServerNode
    attr_reader :url, :options

    def initialize(url, options = {})
      @url = Thenewboston::Util::URL.format_url(url)
      @options = Thenewboston::Util::Options.format_default_options(options)
    end
  end
end
