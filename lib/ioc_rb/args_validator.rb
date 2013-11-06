module IocRb::ArgsValidator
  class << self
    def is_symbol!(obj, obj_name)
      unless obj.is_a?(Symbol)
        raise ArgumentError, "#{obj_name} should be a Symbol"
      end
    end

    def is_array!(obj, obj_name)
      unless obj.is_a?(Array)
        raise ArgumentError, "#{obj_name} should be an Array"
      end
    end

    def is_hash!(obj, obj_name)
      unless obj.is_a?(Hash)
        raise ArgumentError, "#{obj_name} should be a Hash"
      end
    end

    def has_key!(hash, key)
      unless hash.has_key?(key)
        raise ArgumentError, "#{hash} should has #{key} key"
      end
    end

    def block_given!(block)
      unless block
        raise ArgumentError, "Block should be given"
      end
    end
  end
end
