module MyAddition
  def zzz
    'zzz'
  end

  class << self
    attr_accessor :heard
    
    def say message
      @heard = message
    end
  end
end

module MyOtherAddition
  def yyy
    'yyy'
  end

  class << self
    attr_accessor :heard
    attr_accessor :configured
    
    def say message
      @heard = message
    end
  end
end

