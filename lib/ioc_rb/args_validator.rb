# Helper class for arguments validation
module IocRb::ArgsValidator
  class << self

    # Enscure that specifid +obj+ is a symbol
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_symbol!(obj, obj_name)
      unless obj.is_a?(Symbol)
        raise ArgumentError, "#{obj_name} should be a Symbol"
      end
    end

    # Enscure that specifid +obj+ is an Array
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_array!(obj, obj_name)
      unless obj.is_a?(Array)
        raise ArgumentError, "#{obj_name} should be an Array"
      end
    end

    # Enscure that specifid +obj+ is a Hash
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_hash!(obj, obj_name)
      unless obj.is_a?(Hash)
        raise ArgumentError, "#{obj_name} should be a Hash"
      end
    end

    # Enscure that specifid +hash+ has a specified +key+
    # @param hash some hash
    # @param key hash's key
    def has_key!(hash, key)
      unless hash.has_key?(key)
        raise ArgumentError, "#{hash} should has #{key} key"
      end
    end

    # Enscure that specified +block+ is given
    # @param block some block
    def block_given!(block)
      unless block
        raise ArgumentError, "Block should be given"
      end
    end
  end
end
