# frozen_string_literal: false

require "rbnacl"

module Thenewboston
  # Create accounts for thenewboston
  class Account
    attr_reader :account_number_hex, :signing_key_hex, :account_number, :signing_key
    def initialize(signing_key_seed = "")
      if signing_key_seed == ""
        @signing_key = RbNaCl::SigningKey.generate
      elsif signing_key_seed.to_s.length != 64
        raise "Signing key provided should be 64 characters"
      else
        @signing_key = RbNaCl::SigningKey.new(str_to_key(signing_key_seed))
      end
      @account_number = @signing_key.verify_key

      @account_number_hex = key_to_str(@account_number.to_bytes)
      @signing_key_hex = key_to_str(@signing_key.to_bytes)
    end

    def key_to_str(key)
      key.each_byte.map { |byte| format("%<byte>02x", byte: byte) }.join
    end

    def str_to_key(str)
      "".tap { |binary| str.scan(/../) { |hn| binary << hn.to_i(16).chr } }
    end
  end
end
