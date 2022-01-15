# frozen_string_literal: true

require "test_helper"

class TestBank < Minitest::Test
  def test_that_bank_can_be_created_with_valid_url
    bank_url = "http://54.183.16.194"
    bank = Thenewboston::Bank.new(bank_url)
    assert_equal bank_url, bank.url
  end

  def test_that_bank_cannot_be_created_with_invalid_url
    err = assert_raises RuntimeError do
      Thenewboston::Bank.new("http://bank")
    end
    assert_match "URL must a valid url in the format http://[subdomain].domain.com", err.message
  end
end
