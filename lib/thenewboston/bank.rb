# frozen_string_literal: true

module Thenewboston
  # Interact with banks for thenewboston
  class Bank < ServerNode
    def get_transactions(options = {})
      get_paginated_data("/bank_transactions", options)
    end

    def get_bank(node_identifier)
      get_data("/banks/#{node_identifier}")
    end

    def get_banks(options = {})
      get_paginated_data("/banks", options)
    end

    def get_config # rubocop:disable Naming/AccessorMethodName
      get_data("/config")
    end

    def update_account_trust(account_number, trust, account)
      patch_data("/accounts/#{account_number}", account.create_signed_message({ trust: trust }))
    end
  end
end
