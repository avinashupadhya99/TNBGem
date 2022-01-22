# frozen_string_literal: false

module Thenewboston
  # Utility functions
  module Util
    # Functions for string conversions
    module Conversions
      def self.key_to_str(key)
        key.each_byte.map { |byte| format("%<byte>02x", byte: byte) }.join
      end

      def self.str_to_key(str)
        "".tap { |binary| str.scan(/../) { |hn| binary << hn.to_i(16).chr } }
      end

      def self.hash_to_str(hash)
        if hash.is_a?(String)
          "\"#{hash}\""
        elsif hash.is_a?(Integer)
          hash.to_s
        else
          "{" + hash.map { |k, v| "\"#{k}\":#{hash_to_str(v)}" }.join(",") + "}"
        end
      end
    end
  end
end
