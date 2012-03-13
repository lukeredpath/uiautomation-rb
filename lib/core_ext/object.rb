unless Object.respond_to?(:try)
  class Object
    def try(method)
      nil? || send(method)
    end
  end
end
