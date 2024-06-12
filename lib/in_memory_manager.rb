class InMemoryManager
  def self.increment(key)
    Redis.incr(key)
  end

  def self.get(key)
    Redis.get(key)
  end

  def self.set(key,value)
    Redis.set(key,value)
  end
end
