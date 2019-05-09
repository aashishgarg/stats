module Stats
  class Server
    # --- Attribute Accessors --- #
    attr_accessor :processes, :result

    def initialize
      @result = {}
      @processes = get_processes
      build_result(@processes)
    end

    def get_processes
      # `export SUDO_ASKPASS=#{ask_pass_path};sudo -A netstat -nlp | grep #{app_server} | grep 'tcp' | awk '{print $4, $7 }'`
      `lsof -wni | grep ruby | awk '{print $2,$9}'`
    end

    def start_time(pid)
      `ps -eo pid,lstart | grep #{pid} | awk '{print $4"-"$3"-"$6" Time - "$5"("$2")"}'`.delete("\n")
    end

    def location(pid)
      sanitized_location(`pwdx #{pid}`, pid)
    end

    def sanitized_location(location, pid)
      location.delete(pid).delete("\n").delete(' :')
    end

    def processes
      @result.keys
    end

    def ports
      @result.values.collect {|hash| hash[:port]}
    end

    def locations
      @result.values.collect {|hash| hash[:location]}
    end

    def release
      `lsb_release -ds ` + `/bin/uname -r`.chomp
    end

    def build_result(string)
      nested_array = string.split("\n").collect {|pair| pair.split(' ')}
      nested_array.each do |array|
        pid, port = *array
        @result[pid] = {
            port: port,
            location: location(pid),
            start_time: start_time(pid)
        }
      end
    end
  end
end
