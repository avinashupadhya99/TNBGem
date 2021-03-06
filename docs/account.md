# Account

In this section, we will discuss how to create accounts and use them within other parts of your code with ease.

## Creating Accounts

Creating local accounts with thenewboston gem is extremely simple. All you have to do is access the `Account` class under the `Thenewboston` module from the library. These accounts are also used when updating thenewboston server nodes (banks + validators) with requests. Here is a simple example of us using the `Account` class:

```rb
# Generates a random account with a random hex signing key string.
account = Thenewboston::Account.new

account.account_number_hex # random account number hex string
account.signing_key_hex # random account signing key hex string
```

As you can tell, if you don't pass in anything into the `Account` class, then it just generates a random account for you. Now, let's get a little more complex, you can pass in the `signing_key` as the first parameter within `Account` and it will set the `signing_key_hex` of the `Account` as it. Also, since we are using the signing-based cryptographic algorithms, the `account_number_hex` can be generated automatically. Here is an example of this behavior in action:

```rb
signing_key = "15fbd07fc5e5764bf5919ad41151066f0708e9e2dc11dd42dd1dd671e9485b20"
account = Thenewboston::Account.new(signing_key)

account.account_number_hex # the corresponding account number hex
account.signing_key_hex # the account signing key
```

> Remember: You **must** keep your account signing key secret at all times. If someone obtains your signing key, then your account is compromised along with all of its funds.

Alright, so we have checked out all of the other ways of instantiating an `Account` with this library.


## Getting Account Numbers and Signing Keys

Obviously, this was used in the earlier examples when we were getting the account number and signing key as a hex string. Here is an example of us getting the `account_number_hex` and `signing_key_hex` of a random `Account`:

```rb
account = Thenewboston::Account.new

account.account_number_hex # the account number hex string
account.signing_key_hex # the account signing key hex string
```

## Creating Signatures

In this section, we will learn how to create signatures for a given `Account` using the `create_signature` method for a `message`.

> If you don't understand what these signatures and private/public keys _really_ are, then check out [this article by Prevail on the topic](https://www.preveil.com/blog/public-and-private-key/).

The `create_signature` method just takes in one parameter: a `string` that is the message to generate a signature for. Here is an example of us signing `"Hello world"`:

```rb
account = Thenewboston::Account.new
signature = account.create_signature("Hello World") # the generated signature generated using the account's `signingKey` and `message`
```

From running that code, you can see that the `create_signature` method returned a 128 character long hex string signature.

> If you re-run that code multiple times, you will then notice that the generated signature is different. That is because the signature depends on two variables: the account signing key and the message. The account signing key also is changing on every run because we are generating a random `Account` to use, thus resulting in different outcomes.

## Verifying Signatures

If you need to verify a signature for a message, then you can easily use the `Account.valid_signature?` static method. The method takes in the message first, the signature (signed message) second and then the account number last. Here is example of how one might use this method:

```rb
account = Thenewboston::Account.new
message = { greeting: "Hello World" }
signature = account.create_signature(message)

Thenewboston::Account.valid_signature?(message, signature, account.account_number_hex)
# returns true only if the account number was used to sign the message and the signed message matches the signature
```

## Verifying Account Keys

If you need to verify that the given signing key and account number are paired together, then you can easily use the `Account.isValidPair` static method. The method takes in the signing key first and the account number second. Here is example of how one might use this method:

```rb
Thenewboston::Account.valid_keypair?("SIGNING_KEY", "ACCOUNT_NUMBER"); # returns true only if the signing key's public key is the given account number
```

## Using Signed Data and Signed Messages

We have already talked about creating signatures, so let's learn how we can apply them to creating signed messages. Here is an example of us creating a signed message:

> Note that all of the `signature` and `node_identifier` properties that we are generating are _almost_ random as we are not passing any arguments into the `Account` class.

```rb
account = Thenewboston::Account.new

signed_message = account.create_signed_message({ name: "Tuna" })

# {
#     :data=> { :name=> "Tuna" },
#     :node_identifier=> "4c8eef36b3d1466a61806c2a76480c64e5b5a0a7e0b84076d86d029b4e448c05",
#     :signature=>         "61e16531f8ed0db1900c81d2d6591770fc1f10e762eb86e0f4e57ac5c5637e7d5bdc168d2eee36ef26093dc4f8e9205291fb124869fb28d0e6f643d558e9f107"
# } 
```

If you were to log out `account`'s `account_number_hex`, then you would realize that the `node_identifier` is just that account. The reason for that is because only servers have the account signing key to be able to authenticate their requests.


Alright, so that's the `Account` class in a nutshell! If you have any things you would like to add please send a pull request or an issue so we can fix it!
