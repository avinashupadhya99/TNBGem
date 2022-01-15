# frozen_string_literal: false

module Thenewboston
  # Utility functions
  module Util
    # Functions for default options formatting
    module Options
      def self.format_default_options(options)
        # Default Options should look like:
        # {
        # defaultPagination: {
        # limit: 20,
        # offset: 0
        # }
        # }
        # but also allow re-writes to the `defaultPagination` key while having all keys.
        {
          **options,
          defaultPagination: {
            limit: 20,
            offset: 0,
            **(options[:defaultPagination] || {})
          }
        }
      end
    end
  end
end
