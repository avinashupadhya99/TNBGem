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
end
