# frozen_string_literal: true

module Thenewboston
  # Interact with banks for thenewboston
  class Bank < ServerNode
    def get_transactions(options = {})
        get_paginated_data("/bank_transactions", options)
    end
  end
end
