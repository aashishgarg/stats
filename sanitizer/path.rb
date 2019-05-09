require '../sanitizer/base'

module Stats
  module Sanitizer
    class Path < Base
      def repository_path(location, pid)
        location.delete(pid).delete("\n").delete(' :')
      end
    end
  end
end