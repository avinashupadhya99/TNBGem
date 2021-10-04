# frozen_string_literal: true

mydir = __dir__

require_relative "thenewboston/version"

module Thenewboston
  class Error < StandardError; end
  # Your code goes here...
end

Dir.glob(File.join(mydir, "thenewboston", "/**/*.rb")).sort.each { |file| require file }
