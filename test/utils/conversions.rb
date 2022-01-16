# frozen_string_literal: false

class Conversions
    def self.hash_to_str(hash)
        if hash.is_a?(String) || hash.is_a?(Integer)
            "\"#{hash}\""
        elsif hash.is_a?(NilClass)
            ""
        else
            "{" + hash.map { |k, v| "\"#{k}\":#{hash_to_str(v)}" }.join(",") + "}"
        end
    end
end