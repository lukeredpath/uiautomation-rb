class Object
  def try(method)
    nil? || send(method)
  end
end
