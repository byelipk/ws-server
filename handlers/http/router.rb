module Evented
  module Handlers
    module HTTP
      class Router
        def dispatch(request)
          inbound = inbound.split(/\r\n/).map {|l| "<p>#{l}</p>"}.join("\r\n")
          input   = File.read("templates/_html.eruby")
          eruby   = Erubis::Eruby.new(input)
          content = eruby.result(content: inbound)
        end
      end
    end
  end
end
