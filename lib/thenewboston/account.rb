# frozen_string_literal: true

require "rbnacl"

module Thenewboston
  # Create accounts for thenewboston
  class Account
    attr_reader :account_number_hex, :signing_key_hex, :account_number, :signing_key
    def initialize
      @signing_key = RbNaCl::SigningKey.generate
      @account_number = @signing_key.verify_key

      @account_number_hex = key_to_str(@account_number.to_bytes)
      @signing_key_hex = key_to_str(@signing_key.to_bytes)
    end

    def key_to_str(key)
      key.each_byte.map { |byte| format("%<byte>02x", byte: byte) }.join
    end
  end
end
