module Stats
  module Sanitizer
    class Base
      def perform(string)
        string.delete("\n")
      end
    end
  end
end