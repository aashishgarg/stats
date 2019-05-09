require '../sanitizer/base'

module Stats
  module Sanitizer
    class Processor < Base
      def repository_path(location, pid)
        location.delete(pid).delete("\n").delete(' :')
      end

      def processes(string)
        string.split("\n").collect {|pair| pair.split(' ')}
      end
    end
  end
end