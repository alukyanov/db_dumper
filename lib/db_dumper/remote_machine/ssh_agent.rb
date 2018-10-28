module DbDumper
  class RemoteMachine

    # Wrapper around Net::SSH, Net:SCP
    class SshAgent
      attr_reader :config
      attr_reader :block, :ssh

      def initialize(config, &block)
        @config       = config
        @block        = block
        @ssh          = Net::SSH.start(*credentials)
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

      def credentials
        [
          ssh_user.host,
          ssh_user.name,
          keys:       ssh_user.ssh_keys,
          passphrase: ssh_user.passphrase
        ]
      end

      def ssh_user
        @ssh_user ||= config.ssh_user
      end

      def ssh_machine_name
        "#{ssh_user.name}@#{ssh_user.host}"
      end

      def log(message)
        config.log(message)
      end
    end
  end
end
