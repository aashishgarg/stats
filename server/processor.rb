require '../server/base'
require '../server/commands'
require '../sanitizer/path'

module Stats
  module Server
    class Processor < Base
      # --- Attribute Accessors --- #
      attr_accessor :processes, :result, :repositories, :ports, :pids, :release, :command, :sanitizer

      def initialize
        @result = {}
        @pids = []
        @ports = []
        @repositories = []
        @command = Commands.new
        @sanitizer = Sanitizer::Path.new
        @processes = @command.active_processes
        @release = @command.release
        build_result(@processes)
      end

      def build_result(string)
        nested_array = string.split("\n").collect {|pair| pair.split(' ')}
        nested_array.each do |array|
          pid, port = *array
          @pids << pid
          @ports << port
          @repositories << @command.repository(pid)

          @result[pid] = {
              port: port,
              repository: @sanitizer.repository_path(@command.repository(pid), pid),
              start_time: @command.start_time(pid)
          }
        end
      end
    end
  end
end