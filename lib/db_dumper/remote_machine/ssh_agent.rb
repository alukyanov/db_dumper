module DbDumper
  class RemoteMachine

    # Wrapper around Net::SSH, Net:SCP
    class SshAgent
      attr_reader :credentials, :config
      attr_reader :block, :ssh
      attr_reader :ssh_user_name, :ssh_host_name

      def initialize(credentials, config, &block)
        @credentials  = credentials
        @config       = config
        @block        = block
        @ssh          = Net::SSH.start(*credentials)

        @ssh_host_name = credentials[0]
        @ssh_user_name = credentials[1]
      end

      def exec!(command)
        log("EXECUTING on #{ssh_machine_name}: #{command}")
        log ssh.exec!(command)
      end

      def download!(remote_source, local_dest, options = {})
        log("DOWNLOADING from #{ssh_machine_name}:#{remote_source} to #{local_dest}")
        log ssh.scp.download!(remote_source, local_dest, options)
      end

      def upload!(local_source, remote_dest, options = {})
        log("uploading from #{ssh_machine_name}:#{local_source} to #{remote_dest}")
        log ssh.scp.upload!(local_source, remote_dest, options)
      end

      private

      def ssh_machine_name
        "#{ssh_user_name}@#{ssh_host_name}"
      end

      def log(message)
        config.log(message)
      end
    end
  end
end
