# frozen_string_literal: true

require "test_helper"
require "json"
require_relative "utils/conversions"

class TestBank < Minitest::Test # rubocop:disable Metrics/ClassLength
  # TODO: Before all
  # TODO: Decrease AbcSize for method
  def setup # rubocop:disable Metrics/MethodLength
    bank_url = "http://54.183.16.194"
    node_identifier = "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5"
    account_number = "28e6cb168337a864eb34a0b4d70bb730c288a20872f11825d11fdec724e5562d"

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

    # Bank config stub
    bank_config_file = File.open "test/data/bank/config.json"
    bank_config_data = JSON.parse bank_config_file.read
    bank_config_data_json = bank_config_data.to_json
    stub_request(:get, "#{bank_url}/config")
      .to_return body: bank_config_data_json, headers: { content_type: "application/json" }

    # Accounts stub
    account_details_file = File.open "test/data/bank/account.json"
    account_details_data = JSON.parse account_details_file.read
    account_details_data_json = account_details_data["patch"].to_json
    stub_request(:patch, "#{bank_url}/accounts/#{account_number}")
      .to_return body: account_details_data_json, headers: { content_type: "application/json" }

    # Bank patch stub
    bank_patch_details_data_json = bank_details_data["patch"].to_json
    stub_request(:patch, "#{bank_url}/banks/#{node_identifier}")
      .to_return body: bank_patch_details_data_json, headers: { content_type: "application/json" }
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

  def test_that_bank_can_get_bank_config # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    bank_config = bank.get_config

    bank_configuration = {
      "primary_validator" => {
        "account_number" => "cafd36d7fc4eb7a7a2b2d242432b4af05a70a7fa54ba5bafcaf0a79a44aa9e43",
        "ip_address" => "52.52.160.149",
        "node_identifier" => "245c38bd9cfcff1337e6350826a3016e7b5a76ebc593e6ad89d27f2bda868ebf",
        "port" => 80,
        "protocol" => "http",
        "version" => "v1.0",
        "default_transaction_fee" => 1,
        "root_account_file" => "http://52.52.160.149:80/media/root_account_file.json",
        "root_account_file_hash" => "c7946c8ab7f978c925b91269e260f64fba080e867150fcc73c6310c2f66ca6ef",
        "seed_block_identifier" => "",
        "daily_confirmation_rate" => 1,
        "trust" => "100.00"
      },
      "account_number" => "982dcfc62db8f1733141c8f5c29e25c8b4489dbf237053d1589d9a3909037187",
      "ip_address" => "54.183.16.194",
      "node_identifier" => "88d57e07642fa7e4ee23906aa1bc0db779ee0d4fa442361fd27ec663d4b69ace",
      "port" => 80,
      "protocol" => "http",
      "version" => "v1.0",
      "default_transaction_fee" => 1,
      "node_type" => "BANK"
    }

    assert_equal bank_configuration, bank_config
  end

  def test_that_bank_can_update_account_trust # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    account_number = "28e6cb168337a864eb34a0b4d70bb730c288a20872f11825d11fdec724e5562d"
    account = Thenewboston::Account.new("ba7283b54b1a259e3fa99db44909d6af7ecde24007f82d465ba8c288adeb39ab")
    patched_account_details = bank.update_account_trust(account_number, 10, account)

    account_details = {
      "id" => "4e4380f8-2dff-4a84-96c2-4b331f8a7be8",
      "created_date" => "2021-07-01T04:30:08.212090Z",
      "modified_date" => "2021-07-01T04:30:08.212111Z",
      "account_number" => "28e6cb168337a864eb34a0b4d70bb730c288a20872f11825d11fdec724e5562d",
      "trust" => "99.98"
    }

    assert_equal account_details, patched_account_details
  end

  def test_that_bank_can_update_bank_trust # rubocop:disable Metrics/MethodLength
    bank = Thenewboston::Bank.new("http://54.183.16.194")
    node_identifier = "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5"
    account = Thenewboston::Account.new("ba7283b54b1a259e3fa99db44909d6af7ecde24007f82d465ba8c288adeb39ab")
    patched_bank_details = bank.update_bank_trust(node_identifier, 10, account)

    bank_details = {
      "account_number" => "28e6cb168337a864eb34a0b4d70bb730c288a20872f11825d11fdec724e5562d",
      "ip_address" => "54.183.16.194",
      "node_identifier" => "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5",
      "port" => 80,
      "protocol" => "http",
      "version" => "v1.0",
      "default_transaction_fee" => 1,
      "trust" => "10.00"
    }

    assert_equal bank_details, patched_bank_details
  end
end
