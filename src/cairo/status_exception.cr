module Cairo
  class StatusException < Exception
    getter status : Status
    
    def initialize(@status : Status, message : String? = nil, cause : Exception? = nil)
      super(message, cause)
    end
  end
end
