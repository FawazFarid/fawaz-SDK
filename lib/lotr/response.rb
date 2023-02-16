module Lotr
  class Response
    # Parse the hash, convert the keys to snake_case and define a method dynamically for each key
    def self.parse_to_object!(hash)
      hash.transform_keys! do |k|
        # convert the key to string
        k = k.to_s
        # remove the leading underscore from the key e.g _id => id
        k = k.gsub(/^_/, "")
        # convert the key to snake case
        k.underscore!
        k
      end

      # define a method for every key to access their respective value
      OpenStruct.new(hash)
    end
  end
end

# underscore! method is not available outside of Rails, had to write a simple implementation
class String
  # ruby mutation methods have the expectation to return self if a mutation occurred, nil otherwise. (see http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub-21)
  def underscore!
    gsub!(/(.)([A-Z])/, '\1_\2')
    downcase!
  end
end
