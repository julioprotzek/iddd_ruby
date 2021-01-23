module RabbitMQ
  class ConnectionSettings
    include Assertion

    attr_reader :host, :port, :username, :password, :vhost

    def self.instance(host: '127.0.0.1', port: 5672, vhost: '/', username: 'guest', password: 'guest')
      ConnectionSettings.new(host, port, vhost, username, password)
    end

    def initialize(host, port, vhost, username, password)
      assert_presence(host, 'Host name must be provided.')
      assert_presence(vhost, 'Virtual host must be provided.')
      @host = host
      @port = port
      @vhost = vhost
      @username = username
      @password = password
    end

    def has_port?
      port > 0
    end

    def has_user_credentials?
      username.present? && password.present?
    end
  end
end