module QualtricsAPI
  module Connectable
    attr_reader :connection
  
    def propagate_connection(connectable)
      @connection = connectable.connection
      self
    end
  end
end
