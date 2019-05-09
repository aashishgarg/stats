require '../server/base'

module Stats
  module Server
    class Commands < Base
      def release
        `lsb_release -ds ` + `/bin/uname -r`.chomp
      end

      def active_processes
        # `export SUDO_ASKPASS=#{ask_pass_path};sudo -A netstat -nlp | grep #{app_server} | grep 'tcp' | awk '{print $4, $7 }'`
        `lsof -wni | grep ruby | awk '{print $2,$9}'`
      end

      def start_time(pid)
        `ps -eo pid,lstart | grep #{pid} | awk '{print $4"-"$3"-"$6" Time - "$5"("$2")"}'`.delete("\n")
      end

      def repository(pid)
        `pwdx #{pid}`
        # sanitized_path(`pwdx #{pid}`, pid)
      end
    end
  end
end