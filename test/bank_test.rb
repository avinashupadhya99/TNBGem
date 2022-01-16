# frozen_string_literal: true

require "test_helper"
require "json"
require_relative "utils/conversions"

class TestBank < Minitest::Test
  # TODO: Before all
  # TODO: Decrease AbcSize for method
  def setup # rubocop:disable Metrics/MethodLength
    bank_url = "http://54.183.16.194"
    node_identifier = "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5"

    # Bank transactions stub
    bank_transactions_file = File.open "test/data/bank/bank_transactions.json"
    bank_transactions_data = JSON.parse bank_transactions_file.read
    bank_transactions_data_json = bank_transactions_data.to_json
    stub_request(:get, "#{bank_url}/bank_transactions")
      .with(query: { "limit" => 20, "offset" => 0 })
      .to_return body: bank_transactions_data_json, headers: { content_type: "application/json" }

    # Bank details stub
    bank_details_file = File.open "test/data/bank/banks.json"
    bank_details_data = JSON.parse bank_details_file.read
    all_bank_details_data_json = bank_details_data["get"].to_json
    individual_bank_details_data_json = bank_details_data["get"]["results"][0].to_json
    stub_request(:get, "#{bank_url}/banks/#{node_identifier}")
      .to_return body: individual_bank_details_data_json, headers: { content_type: "application/json" }
    stub_request(:get, "#{bank_url}/banks")
      .with(query: { "limit" => 20, "offset" => 0 })
      .to_return body: all_bank_details_data_json, headers: { content_type: "application/json" }
  end

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

  def test_that_bank_can_get_transactions # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    bank_transactions = bank.get_transactions

    transaction = {
      "id" => "269405df-03d5-447c-9fbc-6d8f721c5947",
      "block" => {
        "id" => "2e77e039-cc1b-43e2-8f2a-d6063406612a",
        "created_date" => "2022-01-15T09:56:08.888570Z",
        "modified_date" => "2022-01-15T09:56:08.888598Z",
        "balance_key" => "b292db4aa024cb32b4509eff8ad492d40411a9806dddbcd188026e7569b2a6e1",
        "sender" => "6e5ea8507e38be7250cde9b8ff1f7c8e39a1460de16b38e6f4d5562ae36b5c1a",
        "signature" => "49aecc382ddd26d6d62787f7e6c1aeec3b345eae44e2fb67a603f32aa619fee7b3b3533a1ca5f1326562f0c2c8d41b2f008aa90fcd59050e7658f9c93bc2dc01" # rubocop:disable Layout/LineLength
      },
      "amount" => 1,
      "fee" => "BANK",
      "memo" => "",
      "recipient" => "982dcfc62db8f1733141c8f5c29e25c8b4489dbf237053d1589d9a3909037187"
    }

    assert_equal transaction, bank_transactions["results"][0]
  end

  def test_that_bank_can_get_data_of_a_bank # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    node_identifier = "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5"
    bank_detail = bank.get_bank(node_identifier)

    bank_details = {
      "account_number" => "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5",
      "ip_address" => "13.233.77.254",
      "node_identifier" => "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5",
      "port" => 80,
      "protocol" => "http",
      "version" => "v1.0",
      "default_transaction_fee" => 1,
      "trust" => "0.00"
    }

    assert_equal bank_details, bank_detail
  end

  def test_that_bank_can_get_data_of_all_banks # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    banks_detail = bank.get_banks

    bank_details = {
      "account_number" => "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5",
      "ip_address" => "13.233.77.254",
      "node_identifier" => "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5",
      "port" => 80,
      "protocol" => "http",
      "version" => "v1.0",
      "default_transaction_fee" => 1,
      "trust" => "0.00"
    }

    assert_equal bank_details, banks_detail["results"][0]
  end
end
