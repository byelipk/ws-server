module Incoming
  class Request
    attr_reader :payload
    def initialize(payload)
      @payload = payload
    end
  end
end
