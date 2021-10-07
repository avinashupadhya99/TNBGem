# frozen_string_literal: true

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
        @signing_key = RbNaCl::SigningKey.new(Thenewboston::Util::Conversions.str_to_key(signing_key_seed))
      end
      @account_number = @signing_key.verify_key

      @account_number_hex = Thenewboston::Util::Conversions.key_to_str(@account_number.to_bytes)
      @signing_key_hex = Thenewboston::Util::Conversions.key_to_str(@signing_key.to_bytes)
    end

    def create_signature(message)
      message = Thenewboston::Util::Conversions.hash_to_str(message) unless message.is_a?(String)
      Thenewboston::Util::Conversions.key_to_str(@signing_key.sign(message))
    end

    def create_signed_message(message)
      message_str = Thenewboston::Util::Conversions.hash_to_str(message)
      signature = Thenewboston::Util::Conversions.key_to_str(@signing_key.sign(message_str))
      {
        data: message,
        node_identifier: @account_number_hex,
        signature: signature
      }
    end

    def self.valid_keypair?(account_number_string, signing_key_string)
      new(signing_key_string).account_number_hex == account_number_string
    rescue StandardError
      false
    end
  end
end
