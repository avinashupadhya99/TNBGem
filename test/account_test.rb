# frozen_string_literal: true

require "test_helper"

class TestAccount < Minitest::Test
  def setup; end

  def test_that_account_has_account_number_with_64_length
    account = Thenewboston::Account.new
    assert_equal 64, account.account_number_hex.length, "Account number hex should be of 64 length"
  end

  def test_that_account_has_signing_key_with_64_length
    account = Thenewboston::Account.new
    assert_equal 64, account.signing_key_hex.length, "Signing key hex should be of 64 length"
  end

  def test_that_account_can_be_created_with_an_existing_signing_key
    signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
    account = Thenewboston::Account.new(signing_key)
    assert_equal signing_key, account.signing_key_hex, "Signing key hex of the account created should be the same as
    the signing key used for creation"
  end

  def test_that_account_cannot_be_created_if_existing_signing_key_is_not_64_characters
    err = assert_raises RuntimeError do
      Thenewboston::Account.new("bf5919ad41151066f")
    end
    assert_match "Signing key provided should be 64 characters", err.message
  end

  def test_that_account_can_create_signatures
    account = Thenewboston::Account.new
    message = "Hello World"
    signature = account.create_signature(message)
    assert_equal 128, signature.length, "Signature generated should have 128 characters"
  end

  def test_that_account_can_create_signed_messages
    account = Thenewboston::Account.new("61647c0dd309646ea5b3868c8c237158483a10484b0485663e4f82a68a10535e")
    message = { trust: "26.90" }
    signed_message = account.create_signed_message(message)

    assert_equal message, signed_message[:data], "Signed message should contain the initial message as data"
    assert_equal account.account_number_hex,
                 signed_message[:node_identifier],
                 "Signed message should contain the account number as the node identifier"
    assert_equal 128,
                 signed_message[:signature].length,
                 "Signed message's signature generated should have 128 characters"
  end

  def test_that_keypairs_can_be_validated
    signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
    account_number = "46c5b1e48822bfc9ce8ecd21b90af2ba70e19088f37d3e40738dfdb71871e8b7"
    assert_equal true, Thenewboston::Account.valid_keypair?(account_number, signing_key)
  end

  def test_that_keypair_validation_does_not_throw_errors_for_invalid_keys
    signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
    account_number = "guhuigtr"
    assert_equal false, Thenewboston::Account.valid_keypair?(signing_key, account_number)
    assert_equal false, Thenewboston::Account.valid_keypair?(account_number, signing_key)
  end
end
