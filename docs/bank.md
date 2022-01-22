# Bank

In this section, we will discuss how to interact with thenewboston banks using your code.

## Creating Banks

Creating a Bank object will allow you to interact with thenewboston bank through code. It takes the URL of the bank as a parameter.

```rb
# Instantiates a new bank
bank = Thenewboston::Bank.new("http://54.183.16.194")
```

You can get the URL passed as a parameter once the object is created - 

```rb
bank.url
# http://54.183.16.194
```

It also takes a second optional parameter to specify the pagination options. In case it is not passed, there are default values set -

```rb
bank.options
# {:defaultPagination=>{:limit=>20, :offset=>0}} 
```

You can set your pagination options while creating the bank object as follows -

```rb
bank = Thenewboston::Bank.new("http://54.183.16.194", {defaultPagination: {limit: 10, offset: 10}})
bank.options
# {:defaultPagination=>{:limit=>10, :offset=>10}}
```

> The defaultPagination object is used as default options, when API calls are made to the bank.

## Get Config

The bank configuration can be retrieved as follows - 

```rb
config = bank.get_config
# {"primary_validator"=>{"account_number"=>"cafd36d7fc4eb7a7a2b2d242432b4af05a70a7fa54ba5bafcaf0a79a44aa9e43", "ip_address"=>"52.52.160.149", "node_identifier"=>"245c38bd9cfcff1337e6350826a3016e7b5a76ebc593e6ad89d27f2bda868ebf", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "root_account_file"=>"http://52.52.160.149:80/media/root_account_file.json", "root_account_file_hash"=>"c7946c8ab7f978c925b91269e260f64fba080e867150fcc73c6310c2f66ca6ef", "seed_block_identifier"=>"", "daily_confirmation_rate"=>1, "trust"=>"100.00"}, "account_number"=>"982dcfc62db8f1733141c8f5c29e25c8b4489dbf237053d1589d9a3909037187", "ip_address"=>"54.183.16.194", "node_identifier"=>"88d57e07642fa7e4ee23906aa1bc0db779ee0d4fa442361fd27ec663d4b69ace", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "node_type"=>"BANK"} 
```

The function `get_config` does not take any parameters. The config includes data like selected primary validator, IP address, port, node identifier and so on.

## Get accounts

We can get the accounts which are linked to the bank with the `get_accounts` method -

```rb
accounts = bank.get_accounts
# {"count"=>382, "next"=>"http://54.183.16.194/accounts?limit=20&offset=20", "previous"=>nil, "results"=>[{"id"=>"4e4380f8-2dff-4a84-96c2-4b331f8a7be8", "created_date"=>"2021-07-01T04:30:08.212090Z", "modified_date"=>"2021-07-01T04:30:08.212111Z", "account_number"=>"a37e2836805975f334108b55523634c995bd2a4db610062f404510617e83126f", "trust"=>"0.00"}, ...]}
```

## Update account trust

The trust for a particular account can be updated as follows

```rb
signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
account = Thenewboston::Account.new(signing_key)
trust = 50
account_details = bank.update_account_trust(account.account_number_hex, trust, account)
# {"id"=>"4e4380f8-2dff-4a84-96c2-4b331f8a7be8", "created_date"=>"2021-07-01T04:30:08.212090Z", "modified_date"=>"2021-07-01T04:30:08.212111Z", "account_number"=>"a37e2836805975f334108b55523634c995bd2a4db610062f404510617e83126f", "trust"=>"50.00"}
```

## Get Transactions

We can get all the bank transactions using the `get_transactions` method -

```rb
transactions = bank.get_transactions
# {"count"=>16652, "next"=>"http://54.183.16.194/bank_transactions?limit=20&offset=20", "previous"=>nil, "results"=>[{"id"=>"65541a71-19b2-464d-aea2-71c9a0602e08", "block"=>{"id"=>"cf4dc112-61c8-45fd-9aaa-76abe9b9dac4", "created_date"=>"2022-01-22T16:58:40.497600Z", "modified_date"=>"2022-01-22T16:58:40.497629Z", "balance_key"=>"b8b900adbd408bb225803bf581d830c9c538088276c7d5358ca79aa53969324f", "sender"=>"0913b206c1baf493a9c490d8bae279202977b387184c1bd630d0626e9846867b", "signature"=>"79bb2fdb48d95bc32d46ff4e5d42dd083ece5971d60fce59191feda8afa304f8a630e110fd7acad23f823083c504b8c8033c9a961d8078cecdb7afee020f720d"}, "amount"=>1, "fee"=>"BANK", "memo"=>"", "recipient"=>"982dcfc62db8f1733141c8f5c29e25c8b4489dbf237053d1589d9a3909037187"}, {"id"=>"69650fc9-463e-4cd3-9ece-f66f9a9ad0fa", "block"=>{"id"=>"cf4dc112-61c8-45fd-9aaa-76abe9b9dac4", "created_date"=>"2022-01-22T16:58:40.497600Z", "modified_date"=>"2022-01-22T16:58:40.497629Z", "balance_key"=>"b8b900adbd408bb225803bf581d830c9c538088276c7d5358ca79aa53969324f", "sender"=>"0913b206c1baf493a9c490d8bae279202977b387184c1bd630d0626e9846867b", "signature"=>"79bb2fdb48d95bc32d46ff4e5d42dd083ece5971d60fce59191feda8afa304f8a630e110fd7acad23f823083c504b8c8033c9a961d8078cecdb7afee020f720d"}, "amount"=>1, "fee"=>"", "memo"=>"tnb_gifts_437f11061dc9433e9169e66f8afcf18c", "recipient"=>"c4caa42b2a01b31ee187468ac63bd64745f67ec3b20191a54eb55ba20d5adbb0"}, ...]}
```

## Get Banks

We can use `get_banks` method to get all connected banks

```rb
banks = bank.get_banks
# {"count"=>4, "next"=>nil, "previous"=>nil, "results"=>[{"account_number"=>"ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5", "ip_address"=>"13.233.77.254", "node_identifier"=>"ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"0.00"}, {"account_number"=>"855edee3204f0bbc6b14b2d61d56fd06636d6d6400fd3ff97644c11d9588d1e2", "ip_address"=>"45.33.60.42", "node_identifier"=>"8534f05f7eac8cb0cbf4d591c51484fc20c6ee9c522b5213e4572e68d97991be", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"0.00"}, {"account_number"=>"982dcfc62db8f1733141c8f5c29e25c8b4489dbf237053d1589d9a3909037187", "ip_address"=>"54.183.16.194", "node_identifier"=>"88d57e07642fa7e4ee23906aa1bc0db779ee0d4fa442361fd27ec663d4b69ace", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"100.00"}, {"account_number"=>"6ec99cf6656845c526fda71f1b437fe7de965e3c425b96c44b27c12a58872e93", "ip_address"=>"52.2.117.242", "node_identifier"=>"14607d3ee4f50d72ac4204eac9b52e9c8db8dda67347c7eba6e6ea3e8b0de7d9", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"0.00"}]}
```

## Get individual bank

We can also get details about a particular bank using the `get_bank` method and passing the bank's _node_identifier_

```rb
bank_details = bank.get_bank("ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5")
# {"account_number"=>"ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5", "ip_address"=>"13.233.77.254", "node_identifier"=>"ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"0.00"} 
```

## Update bank trust

We can also update the trust of a specific bank by using the `update_bank_trust` method

```rb
signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
network_id_key_pair = Thenewboston::Account.new(signing_key)
trust = 50
bank_to_update = "ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5" 
bank.update_bank_trust(bank_to_update, trust, network_id_key_pair)
# {"account_number"=>"46c5b1e48822bfc9ce8ecd21b90af2ba70e19088f37d3e40738dfdb71871e8b7", "ip_address"=>"54.183.16.194", "node_identifier"=>"ddf057f339fbd165c268bf84956ce186eb4209c8b5e81900509cbbc70b6876c5", "port"=>80, "protocol"=>"http", "version"=>"v1.0", "default_transaction_fee"=>1, "trust"=>"50.00"}
```
