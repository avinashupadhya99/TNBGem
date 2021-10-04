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
end
